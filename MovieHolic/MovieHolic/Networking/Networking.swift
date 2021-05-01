//
//  Networking.swift
//  MovieHolic
//
//  Created by apple on 4/3/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import Foundation

class Networking {
    
    //private let storageMoviesService = MoviesStorageService()
    private var totalPages: Int = 1
    private var currentPage: Int = 1
    private var query: String?
    var canLoadMore: Bool = false
    var strategy: MoviesLoadingType = .popular {
        didSet {
            currentPage = 1
        }
    }
    
    func loadMovies(completion: @escaping ([Movie]?) -> Void) {
        
        var url: URL?
        switch strategy {
        case .popular:
            url = URL(string: K.baseUrl + "movie/popular")
        case .upcoming:
            url = URL(string: K.baseUrl + "movie/upcoming")
        case .topRated:
            url = URL(string: K.baseUrl + "movie/top_rated")
        case .nowPlaying:
            url = URL(string: K.baseUrl + "movie/now_playing")
        case .search(let query):
            url = URL(string: K.baseUrl + "search/movie")
            url = url?.appending("query", value: query)
        }
        
        url = url?.appending("api_key", value: K.apiKey)
        url = url?.appending("page", value: String(currentPage))
        
        guard let urlNotNil = url else {
            return
        }
        
        //let config = URLSessionConfiguration.ephemeral
        //config.waitsForConnectivity = true
        
        let session = URLSession(configuration: .default)
        session.dataTask(with: urlNotNil) { (data, response, error) in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let data = data else {
                return completion(nil)
            }
            do {
                let result = try decoder.decode(MoviesListResponse.self, from: data)
                DispatchQueue.main.async {
                    guard let totalPages = result.totalPages else {
                        return
                    }
                    self.totalPages = totalPages
                    if self.currentPage < totalPages {
                        self.canLoadMore = true
                    } else {
                        self.canLoadMore = false
                    }
                    self.currentPage += 1
                    completion(result.results)
                }
            } catch {
                completion(nil)
            }
        }.resume()
    }
    
    func loadDetails(movieId: Int, completion: @escaping (DetailedMovie?) -> Void) {
        var url: URL?
        url = URL(string: K.baseUrl + "movie/\(movieId)")
        url = url?.appending("api_key", value: K.apiKey)
        guard let urlNotNil = url else {
            return
        }
        URLSession.shared.dataTask(with: urlNotNil) { (data, response, error) in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let data = data else {
                return completion(nil)
            }
            do {
                let result = try decoder.decode(DetailedMovie.self, from: data)
                DispatchQueue.main.async {
                    completion(result)
                }
            } catch {
                completion(nil)
            }
        }.resume()
    }
    
    func loadVideos(movieId: Int, completion: @escaping ([Video]?) -> Void) {
        var url: URL?
        url = URL(string: K.baseUrl + "movie/\(movieId)/videos")
        url = url?.appending("api_key", value: K.apiKey)
        guard let urlNotNil = url else {
            return
        }
        URLSession.shared.dataTask(with: urlNotNil) { (data, response, error) in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let data = data else {
                return
            }
            do {
                let result = try decoder.decode(VideosResponse.self, from: data) 
                DispatchQueue.main.async {
                    completion(result.results)
                }
            } catch {
                completion(nil)
            }
        }.resume()
    }
    
    func loadCast(movieId: Int, completion: @escaping ([CastEntry]?) -> Void) {
        guard
            let url = URL(string: K.baseUrl + "movie/\(movieId)/credits")?
                .appending("api_key", value: K.apiKey)
            else {
                return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let data = data else {
                return
            }
            do {
                let result = try decoder.decode(CreditsResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(result.cast)
                }
            } catch {
                completion(nil)
            }
        }.resume()
    }
    
}


