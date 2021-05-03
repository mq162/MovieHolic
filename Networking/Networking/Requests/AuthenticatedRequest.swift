//
//  AuthenticatedRequest.swift
//  Networking
//
//  Created by Quang Phạm on 02/05/2021.
//

import Alamofire

struct AuthenticatedRequest: URLRequestConvertible {
    
    let credentials: Credentials

    let request: URLRequestConvertible

    func asURLRequest() throws -> URLRequest {
        var authenticated = try request.asURLRequest()
        
        authenticated.url?.appending("api_key", value: credentials.apiKey)
        authenticated.setValue("Bearer " + credentials.authToken, forHTTPHeaderField: "Authorization")
        authenticated.setValue("application/json", forHTTPHeaderField: "Accept")
        authenticated.addValue("application/json", forHTTPHeaderField: "Content-Type")

        return authenticated
    }
}
