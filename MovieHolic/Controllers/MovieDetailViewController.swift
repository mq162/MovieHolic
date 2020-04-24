//
//  MovieDetailViewController.swift
//  MovieHolic
//
//  Created by apple on 4/4/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit
import UICircularProgressRing
import AVKit

class MovieDetailViewController: UIViewController {

    @IBOutlet weak var backdropImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var taglineLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var rateView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var budgetLabel: UILabel!
    @IBOutlet weak var revenueLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var videosCollectionView: UICollectionView!
    
    var progressRing: UICircularProgressRing!
    var movieId: Int?
    var networking = Networking()
    var detailedMovie: DetailedMovie?
    var extractor = LinkExtractor()
    private var videos: [Video] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true

        loadDetails()
        configureView()
        
        progressRing = UICircularProgressRing(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        rateView.backgroundColor = #colorLiteral(red: 0.03137254902, green: 0.1098039216, blue: 0.1333333333, alpha: 1)
        progressRing.style = .ontop
        progressRing.maxValue = 100
        progressRing.startAngle = 280
        progressRing.outerRingWidth = 2
        progressRing.fontColor = .white
        rateView.makeCircular()
        rateView.addSubview(progressRing)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        progressRing.startProgress(to: CGFloat((detailedMovie?.voteAverage ?? 0.0) * 10.0), duration: 1.5)
    }
    
    private func loadDetails() {
        guard let movieId = movieId else {
            return
        }

        networking.loadDetails(movieId: movieId) { [weak self] (result) in
            guard let result = result, let self = self else {
                return
            }
            self.detailedMovie = result
            self.updateView()
        }
        
        networking.loadVideos(movieId: movieId) { [weak self] (result) in
            guard let result = result, let self = self else {
                return
            }
            self.videos = result
            self.videosCollectionView.reloadData()
        }
        
    }
    
    private func configureView() {
        contentView.applyShadow(radius: 20, opacity: 0.1, offsetW: 4, offsetH: 4)
        //contentView.layer.cornerRadius = 20
        
        videosCollectionView.register(UINib(nibName: VideoCollectionViewCell.identifier, bundle: nil),forCellWithReuseIdentifier: VideoCollectionViewCell.identifier)
        videosCollectionView.delegate = self
        videosCollectionView.dataSource = self
    }
    
    private func updateView() {
        
        backdropImage.loadFullPicture(path: detailedMovie?.backdropPath)
        backdropImage.layer.cornerRadius = 10
        //backdropImage.applyShadow(radius: 10, opacity: 0.2, offsetW: 2, offsetH: 2)
        //backdropImage.addBlurEffect()
        titleLabel.text = detailedMovie?.title
        taglineLabel.text = detailedMovie?.tagline
        overviewLabel.text = detailedMovie?.overview
        releaseDateLabel.text = detailedMovie?.releaseDate?.formatDate()
        
        if let vote = detailedMovie?.voteAverage {
            if vote >= 7.0 {
                progressRing.innerRingColor = #colorLiteral(red: 0.1294117647, green: 0.8156862745, blue: 0.4784313725, alpha: 1)
                progressRing.outerRingColor = #colorLiteral(red: 0.1215686275, green: 0.2705882353, blue: 0.1607843137, alpha: 1)
            } else if vote >= 4.0 && vote < 7.0 {
                progressRing.innerRingColor = #colorLiteral(red: 0.8235294118, green: 0.8352941176, blue: 0.1960784314, alpha: 1)
                progressRing.outerRingColor = #colorLiteral(red: 0.262745098, green: 0.2392156863, blue: 0.05882352941, alpha: 1)
            } else {
                progressRing.innerRingColor = #colorLiteral(red: 0.8588235294, green: 0.1333333333, blue: 0.3764705882, alpha: 1)
                progressRing.outerRingColor = #colorLiteral(red: 0.3411764706, green: 0.07843137255, blue: 0.2078431373, alpha: 1)
            }
        }
        
        if detailedMovie?.budget == 0 {
            budgetLabel.text = "Information is coming soon"
        } else if let budget = detailedMovie?.budget {
            self.budgetLabel.text = "\(budget.numFormat())$"
        }
        if detailedMovie?.revenue == 0 {
            revenueLabel.text = "Information is coming soon"
        } else if let revenue = detailedMovie?.revenue {
            self.revenueLabel.text = "\(revenue.numFormat())$"
        }
        if detailedMovie?.runtime == 0 {
            runtimeLabel.text = "Information is coming soon"
        } else if let runtime = detailedMovie?.runtime {
            let runtimeHours = runtime / 60
            let runtimeMins = runtime % 60
            self.runtimeLabel.text = "\(runtimeHours)h \(runtimeMins)m"
        }

        languageLabel.text = detailedMovie?.originalLanguage 
        
    }

}

//MARK: - CollectionView Data Source

extension MovieDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == videosCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.identifier,
                                                          for: indexPath) as? VideoCollectionViewCell
            cell?.configure(video: videos[indexPath.row])
            return cell ?? UICollectionViewCell()
        } else {
            return UICollectionViewCell()
        }
    }
    
    
}

//MARK: - CollectionView Delegate

extension MovieDetailViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
            if collectionView == videosCollectionView {
                extractor.getUrlFromKey(key: videos[indexPath.row].key) { [weak self] (url) in
                    guard let self = self else {
                        return
                    }
                    let player = AVPlayer(url: url)
                    let vc = AVPlayerViewController()
                    vc.player = player
                    self.present(vc, animated: true) {
                        vc.player?.play()
                    }
                }
            }
        }
} 
