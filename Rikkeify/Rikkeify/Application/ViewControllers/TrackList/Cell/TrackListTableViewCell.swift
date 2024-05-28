//
//  TrackListTableViewCell.swift
//  Rikkeify
//
//  Created by PearUK on 14/5/24.
//

import UIKit

class TrackListTableViewCell: UITableViewCell {
    @IBOutlet private weak var thumbImageView: UIImageView!
    @IBOutlet private weak var artistLabel: UILabel!
    @IBOutlet private weak var nameLabel: UILabel!
    
    func configure(isSelected: Bool, track: Track, thumbImage: String) {
        let imageUrl = track.album?.cover.first?.url ?? ""
        let finalImageUrl = imageUrl == "" ? thumbImage : imageUrl
        
        thumbImageView.setNetworkImage(urlString: finalImageUrl)
        artistLabel.text = track.artists.first?.name
        nameLabel.text = track.name
        
        nameLabel.textColor = isSelected ? .systemGreen : .white
    }
}
