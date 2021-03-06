//
//  CollectionCell.swift
//  CollectionExample
//
//  Created by Appinventiv on 27/02/18.
//  Copyright © 2018 Appinventiv. All rights reserved.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var starImage: UIImageView!
    
    let resourceString = "https://image.tmdb.org/t/p/w200"
    
    func configure(with model: Movie?) {
        titleLabel.text = model?.original_title
        if let posterPath = model?.poster_path {
            guard let resourceURL = URL(string: resourceString + posterPath) else {
                fatalError()
            }
            imageView.load(url: resourceURL)
        }
        starImage.isHidden = !(model?.isFavorite ?? false)
      
        
    }
}

extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
