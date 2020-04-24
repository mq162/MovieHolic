//
//  Extension.swift
//  MovieHolic
//
//  Created by apple on 4/1/20.
//  Copyright © 2020 Minh Quang. All rights reserved.
//

import UIKit
import Nuke

extension UIImageView {
    func loadPicture(posterPath: String?) {
        let blankImageUrl = "https://image.tmdb.org/t/p/w500"
        if let pathNotNil = posterPath,
            let imageUrl = URL(string: blankImageUrl + pathNotNil) {
            Nuke.loadImage(with: imageUrl, into: self)
        }
    }

    func loadFullPicture(path: String?) {
        let blankImageUrl = "https://image.tmdb.org/t/p/original"
        if let pathNotNil = path,
            let imageUrl = URL(string: blankImageUrl + pathNotNil) {
            Nuke.loadImage(with: imageUrl, into: self)
        }
    }
    
    func loadVideoPreview(key: String?) {
        guard let key = key else {
            return
        }
        let blankImageUrl = "https://img.youtube.com/vi/\(key)/0.jpg"
        if let imageUrl = URL(string: blankImageUrl) {
            Nuke.loadImage(with: imageUrl, into: self)
        }
    }
}


extension URL {
    func appending(_ queryItem: String, value: String?) -> URL? {
        guard var urlComponents = URLComponents(string: absoluteString) else {
            return absoluteURL
        }

        // Create array of existing query items
        var queryItems: [URLQueryItem] = urlComponents.queryItems ??  []

        // Create query item
        let queryItem = URLQueryItem(name: queryItem, value: value)

        // Append the new query item in the existing query items array
        queryItems.append(queryItem)

        // Append updated query items array in the url component object
        urlComponents.queryItems = queryItems

        // Returns the url from new url components
        return urlComponents.url
    }
}

extension UIImageView
{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds

        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}

extension UIView {
    func makeCircular() {
        self.layer.cornerRadius = min(self.frame.size.height, self.frame.size.width) / 2.0
        self.clipsToBounds = true
    }
    
    func applyShadow(radius: CGFloat, opacity: Float, offsetW: Int, offsetH: Int) {
        let color: UIColor = .black
        self.layer.shadowRadius = radius
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: offsetW, height: offsetH)
        self.layer.masksToBounds = false
    }
}

extension String {
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let FormattedDate = DateFormatter()
        FormattedDate.dateFormat = "dd/MM/yyyy"
        
        if let date = dateFormatter.date(from: self) {
            return FormattedDate.string(from: date)
        } else {
            return ""
        }
    }
}

extension Int {
    func numFormat() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = NumberFormatter.Style.decimal
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: self))!
    }
    
}
