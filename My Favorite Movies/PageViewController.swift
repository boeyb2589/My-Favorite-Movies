//
//  PageViewController.swift
//  My Favorite Movies
//
//  Created by Brandon Boey on 4/26/20.
//  Copyright © 2020 Brandon Boey. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController {
    
    var movies = Movies()
    var locationIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        self.dataSource = self
        setViewControllers([createPosterViewController(forPage: 0)], direction: .forward, animated: false, completion: nil)
    }
    
    
    func createPosterViewController(forPage page: Int) -> PosterViewController {
        let PosterViewController = storyboard!.instantiateViewController(identifier: "PosterViewController") as! PosterViewController
        PosterViewController.locationIndex = page
        return PosterViewController
    }
    

    
}
extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? PosterViewController {
            if currentViewController.locationIndex > 0 {
                return createPosterViewController(forPage: currentViewController.locationIndex - 1)
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let currentViewController = viewController as? PosterViewController {
            if currentViewController.locationIndex < movies.movieArray.count - 1 {
                return createPosterViewController(forPage: currentViewController.locationIndex + 1)
            }
        }
        return nil
    }
    

    
}

