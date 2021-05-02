//
//  Movie.swift
//  Networking
//
//  Created by Quang Phạm on 02/05/2021.
//

import Foundation

public struct Movie: Codable {
    
    public let backdropPath: String?
    public let posterPath: String?
    public let id: Int?
    public let title: String?
    public let voteAverage: Double?
    public let overview: String?
    public let releaseDate: Date?
    public let budget: Int?
    public let revenue: Int?
    public let runtime: Int?
    public let originalLanguage: String?
    public let tagline: String?
}

private extension Movie {
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case id = "id"
        case title = "title"
        case voteAverage = "vote_average"
        case overview = "overview"
        case releaseDate = "release_date"
        case budget = "budget"
        case revenue = "revenue"
        case runtime = "runtime"
        case originalLanguage = "original_language"
        case tagline = "tagline"
    }
}
