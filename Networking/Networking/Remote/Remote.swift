//
//  Remote.swift
//  Networking
//
//  Created by Quang Phạm on 02/05/2021.
//

import Alamofire

public class Remote {

    /// Networking Wrapper: Dependency Injection Mechanism, useful for Unit Testing purposes.
    ///
    let network: Network


    /// Designated Initializer.
    ///
    /// - Parameters:
    ///     - credentials: Credentials to be used in order to authenticate every request.
    ///     - network: Network Wrapper, in charge of actually enqueueing a given network request.
    ///
    public init(network: Network) {
        self.network = network
    }


    /// Enqueues the specified Network Request.
    ///
    /// - Parameters:
    ///     - request: Request that should be performed.
    ///     - completion: Closure to be executed upon completion. Will receive the JSON Parsed Response (if successful)
    ///
    func enqueue(_ request: URLRequestConvertible, completion: @escaping (Any?, Error?) -> Void) {
        network.responseData(for: request) { [weak self] (data, networError) in
            guard let self = self else {
                return
            }

            guard let data = data else {
                completion(nil, networError)
                return
            }

            if let dotcomError = DotcomValidator.error(from: data) {
                self.dotcomErrorWasReceived(error: dotcomError, for: request)
                completion(nil, dotcomError)
                return
            }

            do {
                let document = try JSONSerialization.jsonObject(with: data, options: [])
                completion(document, nil)
            } catch {
                completion(nil, error)
            }
        }
    }


    /// Enqueues the specified Network Request.
    ///
    /// - Important:
    ///     - Parsing will be performed by the Mapper.
    ///
    /// - Parameters:
    ///     - request: Request that should be performed.
    ///     - mapper: Mapper entity that will be used to attempt to parse the Backend's Response.
    ///     - completion: Closure to be executed upon completion.
    ///
    func enqueue<M: Mapper>(_ request: URLRequestConvertible, mapper: M, completion: @escaping (M.Output?, Error?) -> Void) {
        network.responseData(for: request) { [weak self] (data, networkError) in
            guard let self = self else {
                return
            }

            guard let data = data else {
                completion(nil, networkError)
                return
            }

            if let dotcomError = DotcomValidator.error(from: data) {
                self.dotcomErrorWasReceived(error: dotcomError, for: request)
                completion(nil, dotcomError)
                return
            }

            do {
                let parsed = try mapper.map(response: data)
                completion(parsed, nil)
            } catch {
                DDLogError("<> Mapping Error: \(error)")
                completion(nil, error)
            }
        }
    }

    /// Enqueues the specified Network Request.
    ///
    /// - Important:
    ///     - Parsing will be performed by the Mapper.
    ///
    /// - Parameters:
    ///     - request: Request that should be performed.
    ///     - mapper: Mapper entity that will be used to attempt to parse the Backend's Response.
    ///     - completion: Closure to be executed upon completion.
    ///
    func enqueue<M: Mapper>(_ request: URLRequestConvertible, mapper: M,
                            completion: @escaping (Result<M.Output, Error>) -> Void) {
        network.responseData(for: request) { [weak self] result in
            guard let self = self else {
                return
            }

            switch result {
            case .success(let data):
                if let dotcomError = DotcomValidator.error(from: data) {
                    self.dotcomErrorWasReceived(error: dotcomError, for: request)
                    completion(.failure(dotcomError))
                    return
                }

                do {
                    let parsed = try mapper.map(response: data)
                    completion(.success(parsed))
                } catch {
                    DDLogError("<> Mapping Error: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
