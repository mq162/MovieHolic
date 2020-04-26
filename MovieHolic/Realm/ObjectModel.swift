//
//  RealmModel.swift
//  MovieHolic
//
//  Created by apple on 4/26/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import Foundation
import RealmSwift

class MovieObject: Object {
    
    @objc dynamic var backdropPath: String?
    let id = RealmOptional<Int>()
    let voteAverage = RealmOptional<Double>()
    @objc dynamic var releaseDate: String?
    @objc dynamic var posterPath: String?
    @objc dynamic var title: String?
    @objc dynamic var overview: String?

    convenience init(backdropPath: String?,
                     id: Int?,
                     voteAverage: Double?,
                     releaseDate: String?,
                     posterPath: String?,
                     title: String?,
                     overview: String?) {
        self.init()
        self.backdropPath = backdropPath
        self.id.value = id
        self.voteAverage.value = voteAverage
        self.releaseDate = releaseDate
        self.posterPath = posterPath
        self.title = title
        self.overview = overview
    }
}










