//
//  Crew.swift
//  Networking
//
//  Created by Quang Phạm on 02/05/2021.
//

import Foundation

public struct Crew: Codable {
    public let creditId: String?
    public let department: String?
    public let gender: Int?
    public let id: Int?
    public let job: String?
    public let name: String?
    public let profilePath: String?
}

private extension Crew {
    
    enum CodingKeys: String, CodingKey {
        case department = "department"
        case id = "id"
        case creditId = "credit_id"
        case gender = "gender"
        case name = "name"
        case job = "job"
        case profilePath = "profile_path"
    }
}
