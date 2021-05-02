//
//  Video.swift
//  Networking
//
//  Created by Quang Phạm on 02/05/2021.
//

import Foundation

public struct Video: Codable {
    public let id: String?
    public let key: String?
    public let name: String?
    public let type: String?
    public let size: Int?
    public let site: String?
}

private extension Video {
    
    enum CodingKeys: String, CodingKey {
        case key = "key"
        case name = "name"
        case id = "id"
        case type = "type"
        case size = "size"
        case site = "site"
    }
}
