//
//  SearchTableViewCell.swift
//  MovieHolic
//
//  Created by apple on 4/4/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    static let identifier = String(describing: SearchTableViewCell.self)
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var shadowImageView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        configureUI()
    }
    
    func configure(movie: Movie) {
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview
        if let yearStr = movie.releaseDate?.prefix(4) {
            yearLabel.text = String(yearStr)
        }
        if movie.posterPath == nil {
            posterImage.contentMode = .center
            posterImage.image = UIImage(named: "noImage")
        } else {
            posterImage.contentMode = .scaleAspectFill
            posterImage.loadPicture(posterPath: movie.posterPath)
        }
        
    }
    
    private func configureUI() {
        cellView.layer.cornerRadius = 10
        cellView.applyShadow(radius: 6, opacity: 0.1, offsetW: 4, offsetH: 4)
        posterImage.layer.cornerRadius = 5
        posterImage.clipsToBounds = true
        shadowImageView.applyShadow(radius: 5, opacity: 0.25, offsetW: 1, offsetH: 0)
        shadowImageView.layer.cornerRadius = 5        
    }
    
}
