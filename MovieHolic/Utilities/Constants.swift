//
//  urlParts.swift
//  MovieHolic
//
//  Created by apple on 4/3/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import Foundation

struct K {
    static let apiKey = "43c76333cdbd2a5869d68050de560ceb"
    static let baseUrl = "https://api.themoviedb.org/3/"
    
    struct baseImageUrl {
        static let poster = "https://image.tmdb.org/t/p/w500"
        static let backdrop = "https://image.tmdb.org/t/p/original"
    }
    
    struct segueIdentifier {
        static let feed = "moviesToDetail"
        static let search = "searchToDetail"
        static let favourite = "favouriteToDetail"
    }
}
