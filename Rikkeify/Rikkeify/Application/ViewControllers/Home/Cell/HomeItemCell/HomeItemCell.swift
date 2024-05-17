//
//  CommonSquaredItemCell.swift
//  Rikkeify
//
//  Created by QuocLA on 16/04/2024.
//

import UIKit

class HomeItemCell: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    
    func configure(title: String, image: String, type: String) {
        titleLabel.text = title
        imageView.setNetworkImage(urlString: image)
        if type == ItemType.artist.rawValue {
            self.layoutIfNeeded()
            imageView.layer.cornerRadius = imageView.frame.width / 2
            titleLabel.textAlignment = .center
        }
    }
}
