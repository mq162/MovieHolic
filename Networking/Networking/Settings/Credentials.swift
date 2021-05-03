//
//  Credentials.swift
//  Networking
//
//  Created by Quang Phạm on 02/05/2021.
//

import Foundation

/// Authenticated Requests Credentials
///
public struct Credentials {
    
    public let apiKey = "43c76333cdbd2a5869d68050de560ceb"

    public let authToken: String

    public init(authToken: String) {
        self.authToken = authToken
    }
}
