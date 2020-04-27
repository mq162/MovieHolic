//
//  ViewController.swift
//  MovieHolic
//
//  Created by apple on 3/31/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController {

    @IBOutlet weak var moviePreferences: UISegmentedControl!
    @IBOutlet weak var movieCollectionView: UICollectionView!
    @IBOutlet weak var bannerCollectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private lazy var networking = Networking()
    private var movieArray: [Movie] = []
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Movie>! = nil
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Movie>
    
    private var currentSnapshot: Snapshot?
    private var timer: Timer!
            
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieCollectionView.register(UINib(nibName: MovieCell.identifier, bundle: nil), forCellWithReuseIdentifier: MovieCell.identifier)
        bannerCollectionView.register(UINib(nibName: BannerCell.identifier, bundle: nil), forCellWithReuseIdentifier: BannerCell.identifier)
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
            networking.strategy = .popular
            segmentBehavior()
        case 1:
            networking.strategy = .nowPlaying
            segmentBehavior()
        case 2:
            networking.strategy = .topRated
            segmentBehavior()
        default:
            break
        }
   }
    
    func segmentBehavior() {
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        movieArray = []
        fetchMovies()
        movieCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
    
    
  //MARK: - Banner CollectionView Auto Scroll Behavior
    
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

    private func startTimer() {
        
        self.timer = Timer.scheduledTimer(timeInterval: 4.0, target: self, selector: #selector(scrollToNextCell), userInfo: nil, repeats: true)
    }
    
//MARK: - Configure Movie Data
    
    private func configureDataSource() {
        
        dataSource = UICollectionViewDiffableDataSource<Section, Movie>(collectionView: movieCollectionView) {
        (collectionView: UICollectionView, indexPath: IndexPath, movie: Movie?) -> UICollectionViewCell? in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.identifier, for: indexPath) as? MovieCell else { fatalError("Cannot create new cell")}
            
            if let movieData = movie {
                cell.configure(movie: movieData)
            }
            return cell
        }
    }
    
    // fetch data from API
    private func fetchMovies() {
        networking.loadMovies { [weak self] (results) in
            guard let movies = results, let self = self
                else { return }

            DispatchQueue.main.async {
                self.movieArray.append(contentsOf: movies)
                self.handle(self.movieArray)
            }
        }
    }
    
    private func handle(_ movies: [Movie]) {
        // initialize data
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(movies)
        self.dataSource.apply(snapshot, animatingDifferences: true)
        self.activityIndicator.isHidden = true
        self.activityIndicator.stopAnimating()
        
    }

}

//MARK: - Banner CollectionView Data Source
extension FeedViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = bannerCollectionView.dequeueReusableCell(withReuseIdentifier: BannerCell.identifier, for: indexPath) as? BannerCell else { fatalError("Cannot create new cell") }
        let bannerName = String(indexPath.item + 1)
        cell.bannerImage.image = UIImage(named: bannerName)
        return cell
    }
}

//MARK: - MovieCollectionView Delegate
extension FeedViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == movieArray.count - 5, networking.canLoadMore == true {
            self.fetchMovies()
        }
    }
    
    //Navigation
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: K.segueIdentifier.feed, sender: self)
        
    }
    
    // Prepare Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailVC = segue.destination as! MovieDetailViewController
        if let indexPath = movieCollectionView.indexPathsForSelectedItems {
            let index = indexPath[0]
            detailVC.movieId = movieArray[index.row].id
        }
    }
}


