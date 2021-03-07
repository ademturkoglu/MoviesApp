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
    @IBOutlet weak var favButton: UIButton!
    
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
        let image = viewModel.isFavourite() ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        favButton.setImage(image, for: .normal)
    }
    
    @IBAction func favButtonTouched(_ sender: Any) {
        let defaults = UserDefaults.standard
        if viewModel.isFavourite() {
            let favMovies = defaults.array(forKey: "movies") as? [Int]
            let newFavMovies = favMovies?.filter{ $0 != movieID }
            defaults.set(newFavMovies, forKey: "movies")
            favButton.setImage(UIImage(systemName: "star"), for: .normal)
        } else {
            var favMovies = defaults.array(forKey: "movies") as? [Int] ?? [Int]()
            favMovies.append(movieID)
            defaults.set(favMovies, forKey: "movies")
            favButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
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

