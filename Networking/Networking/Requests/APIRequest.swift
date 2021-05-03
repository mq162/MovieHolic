//
//  APIRequest.swift
//  Networking
//
//  Created by Quang Phạm on 02/05/2021.
//

import Alamofire

struct APIRequest: URLRequestConvertible {
    
    /// API Version
    ///
    let apiVersion: TheMovieDbAPIVersion

    /// HTTP Request Method
    ///
    let method: HTTPMethod

    /// RPC
    ///
    let path: String

    /// Parameters
    ///
    let parameters: [String: Any]?


    /// Designated Initializer.
    ///
    /// - Parameters:
    ///     - apiVersion: Endpoint Version.
    ///     - method: HTTP Method we should use.
    ///     - path: RPC that should be executed.
    ///     - parameters: Collection of String parameters to be passed over to our target RPC.
    ///
    init(apiVersion: TheMovieDbAPIVersion, method: HTTPMethod, path: String, parameters: [String: Any]? = nil) {
        self.apiVersion = apiVersion
        self.method = method
        self.path = path
        self.parameters = parameters ?? [:]
    }

    /// Returns a URLRequest instance representing the current  Request.
    ///
    func asURLRequest() throws -> URLRequest {
        let requestURL = URL(string: Settings.baseURL + apiVersion.path + path)!
        let request = try URLRequest(url: requestURL, method: method, headers: nil)

        return try URLEncoding.default.encode(request, with: parameters)
    }
}
