//
//  Movie.swift
//  My Favorite Movies
//
//  Created by Brandon Boey on 4/20/20.
//  Copyright © 2020 Brandon Boey. All rights reserved.
//

import Foundation

struct Movie: Codable {
    var Title: String
    var Year: String
    var Poster: String
    var `Type`: String
    var Released: String?
    var Awards: String?
    var imdbRating: String?
    
    
}
