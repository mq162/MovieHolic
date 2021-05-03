//
//  NetworkError.swift
//  Networking
//
//  Created by Quang Phạm on 02/05/2021.
//

import Foundation

public enum NetworkError: Error, Equatable {
    
    /// Unauthorized (statusCode = 401)
    ///
    case unauthorized
    
    /// Resource Not Found (statusCode = 404)
    ///
    case notFound

    /// Request Timeout (statusCode = 408)
    ///
    case timeout

    /// Any statusCode that's not in the [200, 300) range!
    ///
    case unacceptableStatusCode(statusCode: Int)
}

extension NetworkError {

    /// Designated Initializer
    ///
    init?(from statusCode: Int) {
        guard StatusCode.success.contains(statusCode) == false else {
            return nil
        }

        switch statusCode {
        case StatusCode.unauthorized:
            self = .unauthorized
        case StatusCode.notFound:
            self = .notFound
        case StatusCode.timeout:
            self = .timeout
        default:
            self = .unacceptableStatusCode(statusCode: statusCode)
        }
    }

    /// Constants
    ///
    private enum StatusCode {
        static let success  = 200..<300
        static let notFound = 404
        static let unauthorized = 401
        static let timeout  = 408
    }
}
