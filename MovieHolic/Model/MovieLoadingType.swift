//
//  MovieLoadingType.swift
//  MovieHolic
//
//  Created by apple on 4/3/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import Foundation

enum MoviesLoadingType {
    case popular
    case topRated
    case upcoming
    case nowPlaying
    case search(query: String?)
}
