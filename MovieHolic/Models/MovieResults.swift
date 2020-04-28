//
//  MovieResults.swift
//  MovieHolic
//
//  Created by apple on 3/31/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import Foundation

enum Section {
    case main
}

struct MoviesListResponse: Codable {
    let page: Int?
    let totalResults: Int?
    let totalPages: Int?
    let results: [Movie]
}

struct Movie: Codable, Identifiable, Hashable {
    
    let identifier = UUID()
    
    let backdropPath: String?
    let posterPath: String?
    let id: Int?
    let title: String?
    let voteAverage: Double?
    let overview: String?
    let releaseDate: String?
}














