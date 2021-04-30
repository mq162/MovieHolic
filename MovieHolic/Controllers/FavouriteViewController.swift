//
//  FavouriteViewController.swift
//  MovieHolic
//
//  Created by apple on 4/25/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit

class FavouriteViewController: UIViewController {
    
    private let service = MoviesStorageService()
    private var movies: [Movie] = []
    
    @IBOutlet private weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: SearchTableViewCell.identifier, bundle: nil),forCellReuseIdentifier: SearchTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        movies = service.getFavoriteMovies()
        tableView.reloadData()
    }
        
}

//MARK: - UITableView Delegate

extension FavouriteViewController: UITableViewDelegate {
    //navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.segueIdentifier.favourite, sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    // prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! MovieDetailViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            detailVC.movieId = movies[indexPath.row].id
        }
    }
}

// MARK: - TableViewDataSource

extension FavouriteViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier,for: indexPath) as? SearchTableViewCell else { fatalError("Cannot create new cell")}
        cell.configure(movie: movies[indexPath.row])
        return cell
    }
    
    // delete cell behavior
    func tableView(_ tableView: UITableView,commit editingStyle: UITableViewCell.EditingStyle,forRowAt indexPath: IndexPath) {
        guard let movieId = movies[indexPath.row].id else {
            return
        }
        if editingStyle == .delete {
            service.removeMovieWithId(id: movieId)
            service.removeDetailedMovieWithId(id: movieId)
        }
        movies = service.getFavoriteMovies()
        tableView.reloadData()
    }
}
    

    


