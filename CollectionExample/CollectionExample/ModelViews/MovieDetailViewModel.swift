//
//  MovieDetailViewModel.swift
//  CollectionExample
//
//  Created by Adem Türkoğlu on 6.03.2021.
//  Copyright © 2021 adem. All rights reserved.
//

import Foundation
class MovieDetailViewModel {
    var state: MovieDetailViewState!
    var changeHandler: ((MovieDetailViewState.Change) -> Void)?
    let resourceString = "https://image.tmdb.org/t/p/w200"
    
    private var isFetching = false
    
    init(id: Int) {
        state = MovieDetailViewState(id: id)
    }
    
    func title() -> String {
        return state.movieDetail?.original_title ?? "-"
    }
    
    func overview() -> String {
        return state.movieDetail?.overview ?? "-"
    }
    
    func voteAvarage() -> Float {
        return state.movieDetail?.vote_average ?? 0.0
    }
    
    func voteCount() -> Int {
        return state.movieDetail?.vote_count ?? 0
    }
    
    func imageUrl() -> URL {
        if let posterPath = state.movieDetail?.poster_path {
            guard let resourceURL = URL(string: resourceString + posterPath) else {
                fatalError()
            }
            return resourceURL
        } else {
            fatalError()
        }

    }
    
    func isFavourite() -> Bool {
        return state.movieDetail?.isFavorite ?? false
    }
    
    func fetchMovieDetails() {
        if isFetching {
            return
        }
        isFetching = true
        changeHandler?(.fetchState(fetching: true))
        let movieRequest = Service(movieId: state.id)
        movieRequest.getMovieDetail {[weak self] result in
            switch result {
            case .failure(let error):
                self?.changeHandler?(.getDetailError(error: error))
                self?.isFetching = false
            case .success(let movie):
                self?.isFetching = false
                self?.state.movieDetail = movie
                self?.changeHandler?(.movieDetail)
            }
        }
        
      
    }
    

}
