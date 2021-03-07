//
//  MoviesViewController.swift
//  CollectionExample
//
//  Created by Adem Türkoğlu on 6.03.2021.
//  Copyright © 2021 adem. All rights reserved.
//

import UIKit

class MoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate ,UICollectionViewDelegateFlowLayout{
    
    private var list = false
    let itemNo = 2
    let searchController = UISearchController(searchResultsController: nil)
    @IBOutlet weak var collectionView: UICollectionView!
    var movieID = 0
    
    @objc func changeLayout(){
        self.list = !self.list
        
        if list{
            self.navigationItem.rightBarButtonItem?.title = "Grid"
        }
        else{
            self.navigationItem.rightBarButtonItem?.title = "List"
        }
        self.collectionView.reloadData()
    }
    
    private var viewModel = MoviesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        setupViewModel()
        setupViewModelHandlers()
        viewModel.reloadData()
        setupSearchController()
        configureNavigationBar()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "List",
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(changeLayout))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView.reloadData()
    }
    
    func configureNavigationBar() {
        navigationItem.title = "Movies"
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.searchController = searchController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "movieDetailSegue") {
            let vc = segue.destination as! MovieDetailViewController
            vc.movieID = movieID
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if !list{
            let collCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath ) as! CollectionCell
            collCell.configure(with: viewModel.itemAtIndex(row: indexPath.row))
            if viewModel.shouldContinuePaging(), indexPath.row == viewModel.numberOfItems() - 1 {
                viewModel.fetchMovies()
            }
            return collCell
        }
        else{
            let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath ) as! ListCell
            listCell.configure(with: viewModel.itemAtIndex(row: indexPath.row))
            if viewModel.shouldContinuePaging(), indexPath.row == viewModel.numberOfItems() - 1 {
                viewModel.fetchMovies()
            }
            return listCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.frame.width
        if list{
            return  CGSize(width: width, height: 120)
        }else{
            let paddingSpace = (itemNo+1) * 5
            let availableWidth = self.view.frame.size.width - CGFloat(paddingSpace)
            let width = availableWidth/CGFloat(itemNo)
            return CGSize(width: width, height: width)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = viewModel.itemAtIndex(row: indexPath.row)
        movieID = selectedMovie?.id ?? 0
        self.performSegue(withIdentifier: "movieDetailSegue", sender: self)
        collectionView.deselectItem(at: indexPath as IndexPath, animated: false)
    }
    
}

extension MoviesViewController {
    private func setupViewModel() {
        viewModel.changeHandler = { [unowned self] change in
            self.viewModelStateChanged(change: change)
        }
    }
    
    func setupViewModelHandlers() {
        viewModel.isFilteringHandler = {[weak self] in
            guard let self = self else {return false}
            return self.searchController.isActive && !self.isSearchBarEmpty
        }
    }
    
    func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "search"
        searchController.searchBar.tintColor = UIColor.black
        definesPresentationContext = true
    }
}

extension MoviesViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    viewModel.filterContent(forText: searchController.searchBar.text!)
  }
}

extension MoviesViewController {
    var isSearchBarEmpty: Bool {
     return searchController.searchBar.text?.isEmpty ?? true
    }

    private func viewModelStateChanged(change: MoviesViewState.Change){
        switch change {
        case let .fetchState(fetching):
            if viewModel.shouldShowMainLoading() {
              //  fetching ? showIndicator() : hideIndicator()
            }
        case .movies:
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        case let .moviesError(error: error):
            print(error ?? "error")
        }
    }
}



