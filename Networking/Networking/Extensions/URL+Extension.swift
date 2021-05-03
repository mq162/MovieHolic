//
//  URL+Extension.swift
//  Networking
//
//  Created by Quang Phạm on 02/05/2021.
//

import Foundation

extension URL {
    func appending(_ queryItem: String, value: String?) {
        guard var urlComponents = URLComponents(string: absoluteString) else {return}

        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []

        // Create query item
        let queryItem = URLQueryItem(name: queryItem, value: value)

        // Append the new query item in the existing query items array
        queryItems.append(queryItem)

        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems
    }
}
