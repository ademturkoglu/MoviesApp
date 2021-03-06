//
//  MovieDetailViewState.swift
//  CollectionExample
//
//  Created by Adem Türkoğlu on 6.03.2021.
//  Copyright © 2021 adem. All rights reserved.
//

import Foundation

struct MovieDetailViewState {
    var movieDetail: MovieDetailResponse?
    var id: Int
}
extension MovieDetailViewState {
    enum Change {
        case getDetailError(error: MoviesErrors?)
        case fetchState(fetching: Bool)
        case movieDetail
    }
}
