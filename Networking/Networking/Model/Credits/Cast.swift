//
//  Cast.swift
//  Networking
//
//  Created by Quang Phạm on 02/05/2021.
//

import Foundation

public struct Cast: Codable {
    public let castId: Int?
    public let character: String?
    public let creditId: String?
    public let gender: Int?
    public let id: Int?
    public let name: String?
    public let order: Int?
    public let profilePath: String?
}

private extension Cast {
    
    enum CodingKeys: String, CodingKey {
        case castId = "cast_id"
        case character = "character"
        case id = "id"
        case creditId = "credit_id"
        case gender = "gender"
        case name = "name"
        case order = "order"
        case profilePath = "profile_path"
    }
}
