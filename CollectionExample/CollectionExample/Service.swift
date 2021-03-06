//
//  Service.swift
//  CollectionExample
//
//  Created by Adem Türkoğlu on 5.03.2021.
//  Copyright © 2021 adem. All rights reserved.
//

import Foundation

enum MoviesErrors: Error {
    case noDataAvailable
    case notProcessData
}

struct Service {
    let resourceURL: URL
    let API_KEY = "fd2b04342048fa2d5f728561866ad52a"
    
    init(page: Int) {
        let resourceString = "https://api.themoviedb.org/3/movie/popular?language=en-US&api_key=\(API_KEY)&page=\(page)"
        
        guard let resourceURL = URL(string: resourceString) else {
            fatalError()
        }
        self.resourceURL = resourceURL
    }
    
    init(movieId: Int) {
        let resourceString = "https://api.themoviedb.org/3/movie/\(movieId)?language=en-US&api_key=\(API_KEY)"
        
        guard let resourceURL = URL(string: resourceString) else {
            fatalError()
        }
        self.resourceURL = resourceURL
    }
    
    
    func getMovies(completion: @escaping(Result<MoviesResponse, MoviesErrors>) -> Void){
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let moviesResponse = try decoder.decode(MoviesResponse.self, from: jsonData)
                completion(.success(moviesResponse))
            } catch {
                completion(.failure(.notProcessData))
            }
            
        }
        dataTask.resume()
    }
    
    func getMovieDetail(completion: @escaping(Result<MovieDetailResponse, MoviesErrors>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: resourceURL) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let movieResponse = try decoder.decode(MovieDetailResponse.self, from: jsonData)
                completion(.success(movieResponse))
            } catch {
                completion(.failure(.notProcessData))
            }
            
        }
        dataTask.resume()
    }
}

