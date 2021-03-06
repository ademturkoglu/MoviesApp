//
//  MovieDetail.swift
//  CollectionExample
//
//  Created by Adem Türkoğlu on 6.03.2021.
//  Copyright © 2021 adem. All rights reserved.
//

import Foundation

struct MovieDetailResponse: Codable {
    var id: Int?
    var poster_path: String?
    var vote_average: Float?
    var vote_count: Int?
    var original_title: String?
    var overview: String?
    var isFavorite: Bool? {
        let defaults = UserDefaults.standard
        let favMovies = defaults.array(forKey: "movies") as? [Int]
        return favMovies?.contains(id ?? 0)
    }
}
