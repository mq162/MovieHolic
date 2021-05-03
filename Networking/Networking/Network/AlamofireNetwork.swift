//
//  AlamofireNetwork.swift
//  Networking
//
//  Created by Quang Phạm on 02/05/2021.
//

import Alamofire

public class AlamofireNetwork: Network {
    
    private let backgroundSessionManager: Alamofire.SessionManager
    
    private let credentials: Credentials
    
    public required init(credentials: Credentials) {
        self.credentials = credentials
        
        let uniqueID = UUID().uuidString
        let configuration = URLSessionConfiguration.background(withIdentifier: "com.pmquang.movieholic.backgroundsession.\(uniqueID)")
        self.backgroundSessionManager = Alamofire.SessionManager(configuration: configuration)
    }
    
    public func responseData(for request: URLRequestConvertible, completion: @escaping (Data?, Error?) -> Void) {
        let authenticated = AuthenticatedRequest(credentials: credentials, request: request)

        Alamofire.request(authenticated)
            .responseData { response in
                completion(response.value, response.networkingError)
            }
    }
    
    public func responseData(for request: URLRequestConvertible, completion: @escaping (Swift.Result<Data, Error>) -> Void) {
        let authenticated = AuthenticatedRequest(credentials: credentials, request: request)

        Alamofire.request(authenticated).responseData { response in
            completion(response.result.toSwiftResult())
        }
    }
    
}

// MARK: - Swift.Result Conversion

private extension Alamofire.Result {
    /// Convert this `Alamofire.Result` to a `Swift.Result`.
    ///
    func toSwiftResult() -> Swift.Result<Value, Error> {
        switch self {
        case .success(let value):
            return .success(value)
        case .failure(let error):
            return .failure(error)
        }
    }
}

private extension Alamofire.DataResponse {

    /// Returns the Networking Layer Error (if any):
    ///
    ///     -   Whenever the statusCode is not within the [200, 300) range.
    ///     -   Whenever there's a `NSURLErrorDomain` error: Bad Certificate, Unreachable, Cancelled (and few others!)
    ///
    /// NOTE: that we're not doing the standard Alamofire Validation, because the stock routine, on error, will never relay
    /// back the response body. And since the Jetpack Tunneling API does not relay the proper statusCodes, we're left in
    /// the dark.
    ///
    /// Precisely: Request Timeout should be a 408, but we just get a 400, with the details in the response's body.
    ///
    var networkingError: Error? {

        // Passthru URL Errors: These are right there, even without calling Alamofire's validation.
        if let error = error as NSError?, error.domain == NSURLErrorDomain {
            return error
        }

        return response.flatMap { response in
            NetworkError(from: response.statusCode)
        }
    }
}
