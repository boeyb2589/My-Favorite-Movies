//
//  PosterViewController.swift
//  My Favorite Movies
//
//  Created by Brandon Boey on 4/26/20.
//  Copyright © 2020 Brandon Boey. All rights reserved.
//

import UIKit

class PosterViewController: UIViewController {
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var imageView: UIImageView!
    var locationIndex = 0
    
    var movies = Movies()

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
//        let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController
//        let weatherLocation = pageViewController.weatherLocations[locationIndex]
//        weatherDetail = WeatherDetail(name: weatherLocation.name, latitude: weatherLocation.latitude, longitude: weatherLocation.longitude)
        
        
        
        
        pageControl.numberOfPages = movies.movieArray.count
        pageControl.currentPage = locationIndex
        imageView.image = loadImage(fileName: movies.movieArray[locationIndex].Title)
        

    }
    

        func loadImage(fileName: String) -> UIImage? {
            
            let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
            
            let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
            let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
            
            if let dirPath = paths.first {
                let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
                let image = UIImage(contentsOfFile: imageUrl.path)
    //            print("Image succcessfully loaded: \(fileName)")
                return image
                
            }
            
            return nil
        }
    
    func loadData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("myFavoriteMovies").appendingPathExtension("json")
        
        guard let data = try? Data(contentsOf: documentURL) else {return}
        let jsonDecoder = JSONDecoder()
        
        do {
            movies.movieArray = try jsonDecoder.decode(Array<Movie>.self, from: data)
        } catch {
            print("Error: Could not load data \(error.localizedDescription)")
        }
    }

    @IBAction func pageControlTapped(_ sender: UIPageControl) {
        let pageViewController = UIApplication.shared.windows.first!.rootViewController as! PageViewController
        
        var direction: UIPageViewController.NavigationDirection = .forward
        
        if sender.currentPage < locationIndex {
            direction = .reverse
        }
        pageViewController.setViewControllers([pageViewController.createPosterViewController(forPage: sender.currentPage)], direction: direction, animated: true, completion: nil)
    }
    
}
