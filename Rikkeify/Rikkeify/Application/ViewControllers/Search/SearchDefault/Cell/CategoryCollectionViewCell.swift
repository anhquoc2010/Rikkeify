//
//  CategoryCollectionViewCell.swift
//  Rikkeify
//
//  Created by QuocLA on 20/05/2024.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var artworkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        artworkImageView.transform = artworkImageView.transform.rotated(by: .pi / 8)
    }

    func configure(category: Category) {
        self.artworkImageView.setNetworkImage(urlString: category.artwork)
        self.titleLabel.text = category.title
        self.backgroundColor = UIColor(hex: category.backgroundColor)
    }
}
