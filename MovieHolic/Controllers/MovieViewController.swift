//
//  ViewController.swift
//  MovieHolic
//
//  Created by apple on 3/31/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {

    @IBOutlet weak var moviePreferences: UISegmentedControl!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    
    private lazy var networking = Networking()
    private var movieArray: [Movie] = []
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Movie>! = nil
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Movie>
    
    private var currentSnapshot: Snapshot?
    var timer: Timer!
            
    override func viewDidLoad() {
        super.viewDidLoad()
        movieCollectionView.register(UINib(nibName: "MovieCell", bundle: nil), forCellWithReuseIdentifier: "movieCell")
        bannerCollectionView.register(UINib(nibName: "BannerCell", bundle: nil), forCellWithReuseIdentifier: "bannerCell")
        bannerCollectionView.dataSource = self
        movieCollectionView.delegate = self
        movieCollectionView.collectionViewLayout = .createLayout()
        fetchMovies()
        configureDataSource()
        startTimer()
        
    }
    
    @IBAction func movieTypesSelected(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            movieArray = []
            networking.strategy = .popular
            fetchMovies()
        case 1:
            movieArray = []
            networking.strategy = .nowPlaying
            fetchMovies()
        case 2:
            movieArray = []
            networking.strategy = .topRated
            fetchMovies()
        default:
            break
        }
   }
    
    @objc func scrollToNextCell(){

        let cellSize = CGSize(width: self.view.frame.width, height: self.view.frame.height)

        //get current content Offset of the Collection view
        let contentOffset = bannerCollectionView.contentOffset
        
        if bannerCollectionView.contentSize.width <= bannerCollectionView.contentOffset.x + cellSize.width
        {
            // scroll to the first cell
            bannerCollectionView.scrollRectToVisible(CGRect(x:0, y:contentOffset.y, width:cellSize.width, height:cellSize.height), animated: true)
        } else {
            //scroll to next cell
            bannerCollectionView.scrollRectToVisible(CGRect(x:contentOffset.x + cellSize.width, y:contentOffset.y, width:cellSize.width, height:cellSize.height), animated: true)
        }
    }

    func startTimer() {

        self.timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true);
    }
    
//MARK: - Configure Movie Data
    
    func configureDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<Section, Movie>(collectionView: movieCollectionView) {
        (collectionView: UICollectionView, indexPath: IndexPath, movie: Movie) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as? MovieCell else { fatalError("Cannot create new cell")}
            
            cell.nameLabel.text = "\(movie.title)"
            cell.movieImageView.loadPicture(posterPath: movie.posterPath)

            return cell
        }
    }
    
    private func fetchMovies() {
        networking.loadMovies { [weak self] (results) in
            guard let movies = results
             else {
                return
            }
            guard let self = self else {
                return
            }
            
                self.movieArray.append(contentsOf: movies)
                self.handle(self.movieArray)
            
        }
    }
    
    func handle(_ movies: [Movie]) {
        
        // initial data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        
           snapshot.appendSections([.main])
           snapshot.appendItems(movies)
           self.dataSource.apply(snapshot, animatingDifferences: true)
            
    }


}

//MARK: - Banner CollectionView Data Source
extension MovieViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = bannerCollectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as! BannerCell
        let bannerName = String(indexPath.item + 1)
        cell.bannerImage.image = UIImage(named: bannerName)
        return cell
    }
}

//MARK: - MovieCollectionView Delegate
extension MovieViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == movieArray.count - 5, networking.canLoadMore == true {
                self.fetchMovies()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "moviesToDetail", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! MovieDetailViewController
        if let indexPath = movieCollectionView.indexPathsForSelectedItems {
            let index = indexPath[0]
            detailVC.movieId = movieArray[index.row].id
        }
    }
}


