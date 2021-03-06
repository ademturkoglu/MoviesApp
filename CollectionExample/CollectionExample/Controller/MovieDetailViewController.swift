//
//  MovieDetailViewController.swift
//  CollectionExample
//
//  Created by Adem Türkoğlu on 6.03.2021.
//  Copyright © 2021 adem. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    private var viewModel: MovieDetailViewModel!
    var movieID = Int()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var voteLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = MovieDetailViewModel(id: movieID)
        setupViewModel()
        viewModel.fetchMovieDetails()
    }
    
    func updateView() {
        titleLabel.text = viewModel.title()
        overviewLabel.text = viewModel.overview()
        voteLabel.text = "Vote Average / Total Count: \(viewModel.voteAvarage()) / \(viewModel.voteCount())"
        imageView.load(url: viewModel.imageUrl())
    }
}
extension MovieDetailViewController {
    private func setupViewModel() {
        viewModel.changeHandler = { [unowned self] change in
            self.viewModelStateChanged(change: change)
        }
    }
}

extension MovieDetailViewController{
    private func viewModelStateChanged(change: MovieDetailViewState.Change){
        switch change {
        case let .fetchState(fetching): break
             // fetching ? showIndicator() : hideIndicator()
        case .getDetailError(error: let error):
            print(error ?? "error")
        case .movieDetail:
            DispatchQueue.main.async {
                self.updateView()
            }
        }
    }
}

