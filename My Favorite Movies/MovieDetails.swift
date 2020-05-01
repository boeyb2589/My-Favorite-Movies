//
//  MovieDetails.swift
//  My Favorite Movies
//
//  Created by Brandon Boey on 4/20/20.
//  Copyright © 2020 Brandon Boey. All rights reserved.
//

import Foundation

class MovieDetail {
    static var url = "http://www.omdbapi.com/?apikey=\(APIkeys.OMDBapiKey)&"
    
    var Title: String!
    var Year: String!
    var Poster: String!
    var Released: String!
    var Plot: String!
    var imdbRating: String!
    var Response: String!
    var Awards: String!
    
    private struct Returned: Codable {
        var Title: String
        var Year: String
        var Poster: String
        var Released: String
        var Plot: String
        var imdbRating: String
        var Response: String
        var Awards: String
    }
    
    func getData(searchString: String, completed: @escaping ()->()) {
        let urlString = "\(Movies.url)\(searchString)"
        print("🕸 We are accessing the url \(urlString)")
        
        // Create a URL - if you need an APIkey, you'd add it here, along with any other data for the call, like latitude or longitude in DarkSky
        guard let url = URL(string: urlString) else {
            print("😡 ERROR: Could not create a URL from \(urlString)")
            completed()
            return
        }
        
        // Create Session
        let session = URLSession.shared
        
        // Get data with .dataTask method
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("😡 ERROR: \(error.localizedDescription)")
            }
            do {
                let returned = try JSONDecoder().decode(Returned.self, from: data!)
//                print("\(returned)")
                self.Response = returned.Response
                
                if (returned.Response) == "True" {
                    self.Title = returned.Title
                    self.Year = returned.Year
                    self.Poster = returned.Poster
                    self.Released = returned.Released
                    self.Plot = returned.Plot
                    self.imdbRating = returned.imdbRating
                    self.Awards = returned.Awards
                }
                
                
                
                
            } catch {
                print("😡 JSON ERROR: \(error.localizedDescription)")
            }
            completed()
        }
        task.resume()
        
    }
    
}
