//
//  MovieDetailStore.swift
//  Steve
//
//  Created by Quang Phạm on 03/05/2021.
//

import Networking

public class MovieDetailStore: Store {
    
    private let remote: MovieDetailRemote
    
    public override init(dispatcher: Dispatcher, network: Network) {
        self.remote = MovieDetailRemote(network: network)
        super.init(dispatcher: dispatcher, network: network)
    }
    
    public init(dispatcher: Dispatcher, network: Network, remote: MovieDetailRemote) {
        self.remote = remote
        super.init(dispatcher: dispatcher, network: network)
    }
    
    /// Registers for supported Actions.
    ///
    override public func registerSupportedActions(in dispatcher: Dispatcher) {
        dispatcher.register(processor: self, for: MovieDetailAction.self)
    }

    /// Receives and executes Actions.
    ///
    public override func onAction(_ action: Action) {
        guard let action = action as? MovieDetailAction else {
            assertionFailure("AccountStore received an unsupported action")
            return
        }
        
        switch action {
        case .loadMovieDetail(let id, let completion):
            loadMovieDetail(id: id, onCompletion: completion)
        }
    }
}

private extension MovieDetailStore {
    func loadMovieDetail(id: Int, onCompletion: @escaping (Movie?, Error?) -> Void) {
        remote.loadMovieDetail(for: id) {(movie, error) in
            guard let movie = movie else {
                onCompletion(nil, error)
                return
            }
            
            onCompletion(movie, nil)
        }
    }
}
