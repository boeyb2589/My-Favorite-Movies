//
//  SplashScreenViewController.swift
//  My Favorite Movies
//
//  Created by Brandon Boey on 4/23/20.
//  Copyright © 2020 Brandon Boey. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {
    @IBOutlet weak var poweredByLabel: UILabel!
    @IBOutlet weak var swipeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let yAtStart = poweredByLabel.frame.origin.y
        poweredByLabel.frame.origin.y = self.view.frame.height
        UIView.animate(withDuration: 1.0, delay: 1.0, animations: {
            self.poweredByLabel.frame.origin.y = yAtStart
        })
        
        let swipeX = self.swipeLabel.frame.origin.x
        
        self.swipeLabel.frame.origin.x = -self.view.frame.width
        
        UIView.animate(withDuration: 0.5, delay: 0.5, animations: {
            self.swipeLabel.frame.origin.x = swipeX
        })
    }
    

    @IBAction func imageSwiped(_ sender: UISwipeGestureRecognizer) {
        if sender.state == .ended {
        performSegue(withIdentifier: "ShowTableView", sender: nil)
        }
    }
}
