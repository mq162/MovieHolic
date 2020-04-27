//
//  MovieDetails.swift
//  MovieHolic
//
//  Created by apple on 4/4/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import Foundation

struct DetailedMovie: Codable {
    let backdropPath: String?
    let overview: String?
    let budget: Int?
    let revenue: Int?
    let title: String?
    let runtime: Int?
    let originalLanguage: String?
    let posterPath: String?
    let id: Int?
    let voteAverage: Double?
    let releaseDate: String?
    let tagline: String?
}

struct CreditsResponse: Codable {
    let id: Int?
    let cast: [CastEntry]?
}

struct CastEntry: Codable {
    let castId: Int?
    let character: String?
    let creditId: String?
    let gender: Int?
    let id: Int?
    let name: String?
    let order: Int?
    let profilePath: String?
}

