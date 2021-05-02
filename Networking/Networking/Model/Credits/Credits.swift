//
//  Credits.swift
//  Networking
//
//  Created by Quang Phạm on 02/05/2021.
//

import Foundation

struct Credits: Codable {
    let cast: [Cast]
    let crew: [Crew]
}

private extension Credits {
    
    enum CodingKeys: String, CodingKey {
        case cast = "cast"
        case crew = "crew"
    }
}
