//
//  MovieDetailAction.swift
//  Steve
//
//  Created by Quang Phạm on 03/05/2021.
//

import Networking


public enum MovieDetailAction: Action {
    case loadMovieDetail(id: Int, onCompletion: (Movie?, Error?) -> Void)
}
