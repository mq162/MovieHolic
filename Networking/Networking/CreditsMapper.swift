//
//  CreditsMapper.swift
//  Networking
//
//  Created by Quang Phạm on 02/05/2021.
//

import Foundation

struct CreditsMapper: Mapper {

    func map(response: Data) throws -> Credits {
        let decoder = JSONDecoder()
        return try decoder.decode(Credits.self, from: response)
    }
}
