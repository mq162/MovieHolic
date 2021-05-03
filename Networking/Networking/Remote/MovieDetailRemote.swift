//
//  MovieDetailRemote.swift
//  Networking
//
//  Created by Quang Phạm on 03/05/2021.
//

import Foundation

public class MovieDetailRemote: Remote {
    
    public func loadMovieDetail(for id: Int, completion: @escaping (Movie?, Error?) -> Void) {
        let path = "movie/\(id)"
        let request = APIRequest(apiVersion: .ver3, method: .get, path: path)
        let mapper = MovieDetailMapper()
        enqueue(request, mapper: mapper, completion: completion)
    }
}
