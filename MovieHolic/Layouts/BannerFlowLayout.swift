//
//  BannerFlowLayout.swift
//  MovieHolic
//
//  Created by apple on 3/31/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit

class BannerFlowLayout: UICollectionViewFlowLayout {
    
    let cellWidth = UIScreen.main.bounds.size.width
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        minimumInteritemSpacing = 0
        minimumLineSpacing = 0
        //sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        itemSize = CGSize(width: cellWidth, height: cellWidth * 100 / 207)
    }
    

}
