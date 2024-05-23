//
//  SearchActiveTableViewCell.swift
//  Rikkeify
//
//  Created by QuocLA on 20/05/2024.
//

import UIKit

class SearchActiveTableViewCell: UITableViewCell {
    @IBOutlet private weak var thumbImageView: UIImageView!
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var titleLabel: UILabel!
    
    func configure(searchItem: SearchItem) {
        thumbImageView.setNetworkImage(urlString: searchItem.image)
        titleLabel.text = searchItem.title
        typeLabel.text = searchItem.type.capitalized
        
        if searchItem.type == ItemType.artist.rawValue {
            self.layoutIfNeeded()
            thumbImageView.layer.cornerRadius = thumbImageView.frame.width / 2
        } else {
            thumbImageView.layer.cornerRadius = 0
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbImageView.image = nil
    }
}
