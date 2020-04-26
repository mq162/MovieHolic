//
//  CastCollectionViewCell.swift
//  MovieHolic
//
//  Created by apple on 4/24/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit

class CastCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: CastCollectionViewCell.self)
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var castLabel: UILabel!
    @IBOutlet weak var characterLabel: UILabel!
    @IBOutlet weak var castImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    func configureCast(castEntry: CastEntry) {
        if castEntry.profilePath == nil {
            castImage.image = UIImage(named: "anonymous")
        } else {
            castImage.loadPicture(posterPath: castEntry.profilePath)
        }
        castLabel.text = castEntry.name
        characterLabel.text = castEntry.character
    }
    
    private func configureView() {
           castImage.layer.cornerRadius = 5
           shadowView.layer.cornerRadius = 5
           shadowView.applyShadow(radius: 6, opacity: 0.07, offsetW: 3, offsetH: 3)
       }

}
