//
//  MoviesStorageService.swift
//  MovieHolic
//
//  Created by apple on 4/26/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import Foundation
import RealmSwift

class MoviesStorageService: StorageService {

    private let realm = try? Realm()

    func getFavoriteMovies() -> [Movie] {
        guard let objects = realm?.objects(MovieObject.self) else { 
            return []
        }
        var movies: [Movie] = []
        for element in objects {
            let movie = Movie(backdropPath: element.backdropPath,
                              posterPath: element.posterPath,
                              id: element.id.value,
                              title: element.title,
                              voteAverage: element.voteAverage.value,
                              overview: element.overview,
                              releaseDate: element.releaseDate)
            movies.append(movie)
        }
        return movies
    }
    
    func getMovieInfo(id: Int?) -> DetailedMovie? {
        guard let id = id else {
            return nil
        }
        guard let object = realm?.objects(DetailedMovieObject.self).filter("id == \(id)").first else {
            return nil
        }
        let movie = DetailedMovie(backdropPath: object.backdropPath,
                                  overview: object.overview,
                                  budget: object.budget.value,
                                  revenue: object.revenue.value,
                                  title: object.title,
                                  runtime: object.runtime.value,
                                  originalLanguage: object.originalLanguage,
                                  posterPath: object.posterPath,
                                  id: object.id.value,
                                  voteAverage: object.voteAverage.value,
                                  releaseDate: object.releaseDate,
                                  tagline: object.tagline)
        return movie
    }
    
    func isListedMovie(id: Int?) -> Bool {
        return isListed(object: MovieObject.self, id: id)
    }
    
    func saveDetailedMovie(detailedMovie: DetailedMovie?) {
        var detailedMovieObject: DetailedMovieObject?
        detailedMovieObject = DetailedMovieObject(title: detailedMovie?.title,
                                                  backdropPath: detailedMovie?.backdropPath,
                                                  overview: detailedMovie?.overview,
                                                  posterPath: detailedMovie?.posterPath,
                                                  originalLanguage: detailedMovie?.originalLanguage,
                                                  runtime: detailedMovie?.runtime,
                                                  budget: detailedMovie?.budget,
                                                  revenue: detailedMovie?.revenue,
                                                  id: detailedMovie?.id,
                                                  voteAverage: detailedMovie?.voteAverage,
                                                  releaseDate: detailedMovie?.releaseDate,
                                                  tagline: detailedMovie?.tagline)
        saveObject(object: detailedMovieObject)
    }
    
    func removeMovieWithId(id: Int?) {
        removeObjectWithId(object: MovieObject.self, id: id)
    }
    
    func removeDetailedMovieWithId(id: Int?) {
        removeObjectWithId(object: DetailedMovieObject.self, id: id)
    }
    
    func saveMovie(detailedMovie: DetailedMovie?) {
        
        let movie = Movie(backdropPath: detailedMovie?.backdropPath,
                          posterPath: detailedMovie?.posterPath,
                          id: detailedMovie?.id,
                          title: detailedMovie?.title,
                          voteAverage: detailedMovie?.voteAverage,
                          overview: detailedMovie?.overview,
                          releaseDate: detailedMovie?.releaseDate)
        
        var movieObject: MovieObject?
        movieObject = MovieObject(backdropPath: movie.backdropPath,
                                  id: movie.id,
                                  voteAverage: movie.voteAverage,
                                  releaseDate: movie.releaseDate,
                                  posterPath: movie.posterPath,
                                  title: movie.title,
                                  overview: movie.overview)
        saveObject(object: movieObject)
    }
}
