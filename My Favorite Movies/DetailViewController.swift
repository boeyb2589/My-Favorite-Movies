//
//  DetailViewController.swift
//  My Favorite Movies
//
//  Created by Brandon Boey on 4/21/20.
//  Copyright © 2020 Brandon Boey. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var awardsLabel: UITextView!
    @IBOutlet weak var favoriteLabel: UIBarButtonItem!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var plotTextView: UITextView!
    @IBOutlet weak var releasedLabel: UILabel!
    var image: UIImage!
    var movie: Movie!
    //    var movies = Movies()
    var movieDetail = MovieDetail()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        self.titleLabel.text = self.movie.Title
        
        
        let replacedSpaces = movie.Title.replacingOccurrences(of: " ", with: "%20")
        movieDetail.getData(searchString: "t=\(replacedSpaces)") {
            DispatchQueue.main.async {
                self.plotTextView.text = self.movieDetail.Plot
                self.releasedLabel.text = "Released: \(self.movieDetail.Released ?? "Unknown")"
                self.awardsLabel.text = self.movieDetail.Awards
                self.movie.Released = self.movieDetail.Released ?? "Unknown"
                self.movie.Awards = self.movieDetail.Awards ?? "Unknown"
                self.movie.imdbRating = self.movieDetail.imdbRating ?? "Unknown"
                
                
            }
            
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        movie.Title = titleLabel.text!    }
    
    
    @IBAction func imageTapped(sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        
        //Adding tap to dismiss label above image
        let label = UILabel(frame: CGRect(x: newImageView.frame.minX+50, y: newImageView.frame.minY+50, width: 414, height: 44))
        label.center = CGPoint(x: 207, y: newImageView.frame.origin.y + 100 )
        label.textAlignment = .center
        label.text = "Tap to Dismiss"
        label.textColor = .white
        newImageView.addSubview(label)
        
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    
    
    
}
