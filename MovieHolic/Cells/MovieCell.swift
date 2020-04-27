//
//  MovieCell.swift
//  MovieHolic
//
//  Created by apple on 3/31/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit

class MovieCell: UICollectionViewCell {
    
    static let identifier = String(describing: MovieCell.self)

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureView()
    }
    
    private func configureView() {
        movieImageView.layer.cornerRadius = 5
        shadowView.layer.cornerRadius = 5
        shadowView.applyShadow(radius: 5, opacity: 0.07, offsetW: 0, offsetH: 0)
    }
    
    func configure(movie: Movie) {
        nameLabel.text = "\(movie.title ?? "")"
        movieImageView.loadPoster(posterPath: movie.posterPath)
    }

}
