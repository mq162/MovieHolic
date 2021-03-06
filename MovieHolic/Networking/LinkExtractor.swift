//
//  LinkExtractor.swift
//  MovieHolic
//
//  Created by apple on 4/24/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import Foundation
import YoutubeDirectLinkExtractor

class LinkExtractor {
    private let youtubeDirectLinkExtractor = YoutubeDirectLinkExtractor()
    func getUrlFromKey(key: String?, completion: @escaping (URL) -> Void) {
        guard let key = key else {
            return
        }
        let urlSting = "https://www.youtube.com/watch?v=\(key)"
        youtubeDirectLinkExtractor.extractInfo(for: .urlString(urlSting),
                                               success: { (info) in
                                                guard let link = info.highestQualityPlayableLink else {
                                                    return
                                                }
                                                guard let url = URL(string: link) else {
                                                    return
                                                }
                                                DispatchQueue.main.async {
                                                    completion(url)
                                                }
        }) { (error) in
            print(error)
        }
    }
}
