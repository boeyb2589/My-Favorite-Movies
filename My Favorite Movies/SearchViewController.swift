//
//  DetailViewController.swift
//  My Favorite Movies
//
//  Created by Brandon Boey on 4/21/20.
//  Copyright © 2020 Brandon Boey. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchCell = SearchTableViewCell()
    var movies = Movies()
    var images: [UIImage] = []
    
    var urlAppendString = ""
    var searchCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        searchBar.becomeFirstResponder()
        
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchCounter += 1
        let replacedSpaces = searchBar.text!.replacingOccurrences(of: " ", with: "%20")
        movies.getData(searchString: "s=\(replacedSpaces)") {
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        movies.movieArray = []
        images = []
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! DetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.movie = movies.movieArray[selectedIndexPath.row]
            destination.image = images[selectedIndexPath.row]
        } else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
            
        } else {
            navigationController!.popViewController(animated: true)
        }
    }
    
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if movies.movieArray.count == 0 {
            let noFavoritesLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
            noFavoritesLabel.textAlignment = .center
            noFavoritesLabel.text = (searchCounter == 0 ? "Begin searching to find movies or shows.":"No results found. Please try again.")
            noFavoritesLabel.numberOfLines = 0
            self.tableView.backgroundView = noFavoritesLabel
            self.tableView.separatorStyle = .none
        } else {
            self.tableView.separatorStyle = .singleLine
            self.tableView.backgroundView = .none
        }
        return movies.movieArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchTableViewCell
        cell.titleLabel?.text = "\(movies.movieArray[indexPath.row].Title) (\(movies.movieArray[indexPath.row].Year))"
        cell.typeLabel.text = movies.movieArray[indexPath.row].Type
        
        if movies.movieArray[indexPath.row].Poster == "N/A" {
            cell.posterImageView.image = UIImage(named: "noposter")
            images.append(cell.posterImageView.image!)
            
            return cell
        } else {
            guard let url = URL(string: movies.movieArray[indexPath.row].Poster) else {
                cell.posterImageView.image = UIImage(named: "noposter")
                return cell
            }
            do {
                let data = try Data(contentsOf: url)
                
                cell.posterImageView.image = UIImage(data: data)
                images.append(cell.posterImageView.image!)
            } catch {
                print("Error trying to get image")
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}
