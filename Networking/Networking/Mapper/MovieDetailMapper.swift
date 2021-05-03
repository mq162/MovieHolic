//
//  MovieDetailMapper.swift
//  Networking
//
//  Created by Quang Phạm on 03/05/2021.
//

import Foundation

struct MovieDetailMapper: Mapper {
    
    func map(response: Data) throws -> Movie {
        let decoder = JSONDecoder()
        return try decoder.decode(Movie.self, from: response)
    }
}
