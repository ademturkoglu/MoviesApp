//
//  MoviesViewState.swift
//  CollectionExample
//
//  Created by Adem Türkoğlu on 5.03.2021.
//  Copyright © 2021 adem. All rights reserved.
//

import Foundation

struct MoviesViewState {
    var items: [Movie] = []
    var response: MoviesResponse? {
        didSet {
            if let movies = response?.results {
                if movies.count < pager.size {
                    pagesLeft = false
                } else {
                    pagesLeft = true
                    pager.page += 1
                }
                items.append(contentsOf: movies)
            }
        }
    }
    var pagesLeft: Bool = false
    var filteredItems: [Movie] = []
    var pager = UserReceiptsPager(page: 1, size: 20)
}

extension MoviesViewState {
    enum Change {
        case fetchState(fetching: Bool)
        case movies
        case moviesError(error: MoviesErrors?)
    }
}

class UserReceiptsPager: Codable {
    var page: Int
    var size: Int
    
    init(page: Int, size: Int) {
        self.page = page
        self.size = size
    }
}


