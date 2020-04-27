//
//  Video.swift
//  MovieHolic
//
//  Created by apple on 4/24/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import Foundation

struct VideosResponse: Codable {
    let id: Int?
    let results: [Video]?
}

struct Video: Codable {
    let id: String?
    let key: String?
    let name: String?
    let type: String?
    let size: Int?
    let site: String?
}


