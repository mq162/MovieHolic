//
//  BannerCell.swift
//  MovieHolic
//
//  Created by apple on 3/31/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit

class BannerCell: UICollectionViewCell {
    
    static let identifier = String(describing: BannerCell.self)
    
    @IBOutlet weak var bannerImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}


