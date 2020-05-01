//
//  MovieDetail.swift
//  My Favorite Movies
//
//  Created by Brandon Boey on 4/22/20.
//  Copyright © 2020 Brandon Boey. All rights reserved.
//

import Foundation

struct MovieDetail: Codable {
    var Title: String
    var Year: String
    var Poster: String
    var Released: String
    var Plot: String
    var imdbRating: String
    var Response: String
}

