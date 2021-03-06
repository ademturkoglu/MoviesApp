//
//  MoviesViewModel.swift
//  CollectionExample
//
//  Created by Adem Türkoğlu on 5.03.2021.
//  Copyright © 2021 adem. All rights reserved.
//

import Foundation

class  MoviesViewModel {
    var state = MoviesViewState()
    var changeHandler: ((MoviesViewState.Change) -> Void)?
    var isFilteringHandler: (() -> (Bool))?

    private var isFetching = false

    func shouldContinuePaging() -> Bool {
        isFiltering ? false : state.pagesLeft
    }

    func numberOfItems() -> Int {
        associatedArray.count
    }

    func shouldShowMainLoading() -> Bool {
        state.pager.page == 0
    }
    
    func itemAtIndex(row: Int) -> Movie? {
        associatedArray[safe: row]
    }

    func fetchMovies() {
        if isFetching {
            return
        }
        isFetching = true
        changeHandler?(.fetchState(fetching: true))
        let movieRequest = Service(page: state.pager.page)
        movieRequest.getMovies {[weak self] result in
            switch result {
            case .failure(let error):
                self?.changeHandler?(.moviesError(error: error))
                self?.isFetching = false
            case .success(let movies):
                self?.isFetching = false
                self?.state.response = movies
                self?.changeHandler?(.movies)
            }
        }
        
      
    }
    
    func filterContent(forText text: String) {
        state.filteredItems = state.items.filter({ (branchViewModel) -> Bool in
            (branchViewModel.title?.lowercased().contains(text.lowercased()))!
        })
        self.changeHandler?(.movies)
    }

    private func resetData() {
        state.pager = UserReceiptsPager(page: 1, size: 20)
        state.items.removeAll()
    }

    func reloadData() {
        resetData()
        fetchMovies()
    }
}

extension MoviesViewModel {
    
  var associatedArray: [Movie] {
    isFiltering ? state.filteredItems : state.items
  }
    
  var isFiltering: Bool {
    isFilteringHandler?() ?? false
  }
  
}
