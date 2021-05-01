//
//  APIVersion.swift
//  Networking
//
//  Created by Quang Phạm on 01/05/2021.
//

import Foundation

/// Defines the supported TheMovieDb API Versions.
///
enum TheMovieDbAPIVersion: String {
    
    case ver3 = "3/"
    case ver4 = "4/"
    
    var path: String {
        return rawValue
    }
}
