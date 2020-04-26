//
//  VideoCollectionViewCell.swift
//  MovieHolic
//
//  Created by apple on 4/23/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: VideoCollectionViewCell.self)

    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var imageShadowView: UIView!
    @IBOutlet weak var previewImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureView()
    }
    
    func configure(video: Video) {
        previewImage.loadVideoPreview(key: video.key)
        titleLabel.text = video.name
    }
    
    
    private func configureView() {
        previewImage.layer.cornerRadius = 5
        previewImage.clipsToBounds = true
        imageShadowView.layer.cornerRadius = 5
        imageShadowView.applyShadow(radius: 6, opacity: 0.07, offsetW: 3, offsetH: 3)
        shadowView.layer.cornerRadius = 5
        shadowView.applyShadow(radius: 6, opacity: 0.07, offsetW: 3, offsetH: 3)
    }

}
