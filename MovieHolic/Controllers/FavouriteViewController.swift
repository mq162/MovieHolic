//
//  FavouriteViewController.swift
//  MovieHolic
//
//  Created by apple on 4/25/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit

class FavouriteViewController: UIViewController {
    
    private let service = Networking()
    private var movies: [Movie] = []
    
    // MARK: - Subviews
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        movies = service.getFavoriteMovies()
        tableView.reloadData()
    }
    
    // MARK: - Private Methods
    
    private func configureView() {
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: SearchTableViewCell.identifier, bundle: nil),
                           forCellReuseIdentifier: SearchTableViewCell.identifier)
        tableView.tableFooterView = UIView()
    }
}

    // MARK: - TableViewDelegate

extension FavouriteViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "favouriteToDetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier,for: indexPath) as? SearchTableViewCell
        cell?.configure(movie: movies[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView,commit editingStyle: UITableViewCell.EditingStyle,forRowAt indexPath: IndexPath) {
        guard let movieId = movies[indexPath.row].id else {
            return
        }
        if editingStyle == .delete {
            service.removeMovie(id: movieId)
            service.removeDetailedMovie(id: movieId)
        }
        movies = service.getFavoriteMovies()
        tableView.reloadData()
    }
}
    

    


