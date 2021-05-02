//
//  MovieList.swift
//  Networking
//
//  Created by Quang Phạm on 02/05/2021.
//

import Foundation

struct MovieList: Codable {
    let page: Int?
    let totalResults: Int?
    let totalPages: Int?
    let results: [Movie]
}

private extension MovieList {
    
    enum CodingKeys: String, CodingKey {
        case page = "page"
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results = "results"
    }
}
