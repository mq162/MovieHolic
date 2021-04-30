//
//  SearchViewController.swift
//  MovieHolic
//
//  Created by apple on 4/4/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private lazy var networking = Networking()
    private var query = ""
    private var movies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
            
    }
    
    private func configureView() {
        activityIndicator.isHidden = true
        tableView.register(UINib(nibName: SearchTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SearchTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        let search = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = search
        search.searchBar.delegate = self
    }
    
    private func addMovies(query: String) {
        networking.loadMovies { [weak self] (results) in
            guard let self = self, let movies = results else {
                return
            }
            DispatchQueue.main.async {
                self.movies.append(contentsOf: movies)
                self.tableView.reloadData()
            }
        }
    }

    private func loadMovies(query: String) {
        networking.strategy = .search(query: query)
        networking.loadMovies { [weak self] (results) in
            guard let movies = results, let self = self else {
                return
            }
            DispatchQueue.main.async {
                self.movies = movies
                self.tableView.reloadData()
            }
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
}

//MARK: - UITableView DatSource
extension SearchViewController: UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as? SearchTableViewCell else { fatalError("Cannot create new cell")}
        cell.configure(movie: movies[indexPath.row])
        cell.selectionStyle = .none
        return cell
    }

}

//MARK: - TableView Delegate
extension SearchViewController: UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           if indexPath.row == movies.count - 5, networking.canLoadMore == true {
            DispatchQueue.main.async {
                self.addMovies(query: self.query)
            }
           }
       }
   // navigation
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.segueIdentifier.search, sender: self)
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
//MARK: - Search Bar Methods

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        guard let searchQuery = searchBar.text else {
            return
        }
        if searchQuery == "" {
            movies.removeAll()
            tableView.reloadData()
            activityIndicator.isHidden = true
            activityIndicator.stopAnimating()
        } else {
            self.query = searchQuery
            self.loadMovies(query: self.query)
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        movies.removeAll()
        tableView.reloadData()
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
}
