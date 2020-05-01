//
//  ViewController.swift
//  My Favorite Movies
//
//  Created by Brandon Boey on 4/16/20.
//  Copyright © 2020 Brandon Boey. All rights reserved.
//

import UIKit

private let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd MMM YYYY"
    return dateFormatter
}()

class ViewController: UIViewController {
    
    @IBOutlet weak var postersButton: UIBarButtonItem!
    @IBOutlet weak var sortSegmentControl: UISegmentedControl!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var movies = Movies()
    
    
    //    var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        loadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.setToolbarHidden(false, animated: false)
//        self.loadData {
//            self.sortBasedOnSegmentPressed()
//            self.tableView.reloadData()
//        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! DetailViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.movie = movies.movieArray[selectedIndexPath.row]
            destination.image = loadImage(fileName: movies.movieArray[selectedIndexPath.row].Title)
            destination.favoriteLabel.title = ""

        } else if segue.identifier == "ShowPoster" {
                let destination = segue.destination as! PageViewController
            destination.movies = movies
            
        } else {
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                tableView.deselectRow(at: selectedIndexPath, animated: true)
            }
        }
    }
    
    @IBAction func unwindFromDetailTableViewController(segue: UIStoryboardSegue) {
        let source = segue.source as! DetailViewController
        saveImage(imageName: source.titleLabel.text!, image: source.imageView.image!)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            movies.movieArray[selectedIndexPath.row] = source.movie
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: movies.movieArray.count, section: 0)
            movies.movieArray.append(source.movie)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
//            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
                    sortBasedOnSegment()
            tableView.reloadData()
        }
        saveData()
    }
    
    func saveData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("myFavoriteMovies").appendingPathExtension("json")
        
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(movies.movieArray)
        do {
            try data?.write(to: documentURL, options: .noFileProtection)
        } catch {
            print("Couldn't saveData")
        }
    }
    
    func loadData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("myFavoriteMovies").appendingPathExtension("json")
        
        guard let data = try? Data(contentsOf: documentURL) else {return}
        let jsonDecoder = JSONDecoder()
        
        do {
            movies.movieArray = try jsonDecoder.decode(Array<Movie>.self, from: data)
            sortBasedOnSegment()
            tableView.reloadData()
        } catch {
            print("Error: Could not load data \(error.localizedDescription)")
        }
    }
    
    
    func saveImage(imageName: String, image: UIImage) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        
        //Checks if file exists, removes it if so.
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
            
        }
        
        do {
            try data.write(to: fileURL)
//            print("Image succcessfully saved \(fileName)")
        } catch let error {
            print("error saving file with error", error)
        }
        
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
    
    @IBAction func editButtonPressed(_ sender: Any) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            editBarButton.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            editBarButton.title = "Done"
            addBarButton.isEnabled = false
        }
    }
    
    func sortBasedOnSegment() {
        switch sortSegmentControl.selectedSegmentIndex {
        case 0:
            movies.movieArray.sort(by: {$0.Title < $1.Title})
        case 1:
            movies.movieArray.sort(by: {dateFormatter.date(from: ($0.Released! == "Unknown" ? "01 Jan 9999" : $0.Released!))! < dateFormatter.date(from: ($1.Released! == "Unknown" ? "01 Jan 9999" : $1.Released!))!})
        case 2:
            movies.movieArray.sort(by: {($0.imdbRating == "Unknown" ? "0.0": $0.imdbRating!) > ($1.imdbRating == "Unknown" ? "0.0": $1.imdbRating!)})
        default:
            print("This shouldn't happen")
        }
    }
    
    @IBAction func sortSegmentPressed(_ sender: UISegmentedControl) {
        sortBasedOnSegment()
        tableView.reloadData()
    }
}



extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if movies.movieArray.count == 0 {
            let noFavoritesLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height))
            noFavoritesLabel.textAlignment = .center
            noFavoritesLabel.text = "No favorites yet. Press the plus to begin adding favorites."
            noFavoritesLabel.numberOfLines = 0
            self.tableView.backgroundView = noFavoritesLabel
            self.tableView.separatorStyle = .none
            editBarButton.isEnabled = false
            addBarButton.isEnabled = true
            postersButton.isEnabled = false
            
        } else {
            self.tableView.separatorStyle = .singleLine
            self.tableView.backgroundView = .none
            editBarButton.isEnabled = true
            tableView.isEditing = false
            postersButton.isEnabled = true
        }
        return movies.movieArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SearchTableViewCell
        cell.titleLabel?.text = "\(movies.movieArray[indexPath.row].Title) (\(movies.movieArray[indexPath.row].Year))"
        cell.typeLabel?.text = "Released: \(movies.movieArray[indexPath.row].Released!)         Rating: \(movies.movieArray[indexPath.row].imdbRating!)"
        cell.posterImageView.image = loadImage(fileName: movies.movieArray[indexPath.row].Title)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            movies.movieArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            saveData()
        }
        
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = movies.movieArray[sourceIndexPath.row]
        movies.movieArray.remove(at:sourceIndexPath.row)
        movies.movieArray.insert(itemToMove, at: destinationIndexPath.row)
        saveData()
    }
}

