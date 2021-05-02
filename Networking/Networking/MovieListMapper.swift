//
//  MovieListMapper.swift
//  Networking
//
//  Created by Quang Phạm on 02/05/2021.
//

import Foundation

struct MovieListMapper: Mapper {
    
    func map(response: Data) throws -> MovieList {
        let decoder = JSONDecoder()
        return try decoder.decode(MovieList.self, from: response)
    }
}
