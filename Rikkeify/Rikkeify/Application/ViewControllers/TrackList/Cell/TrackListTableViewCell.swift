//
//  TrackListTableViewCell.swift
//  Rikkeify
//
//  Created by PearUK on 14/5/24.
//

import UIKit

class TrackListTableViewCell: UITableViewCell {
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    func configure(track: Track, thumbImage: String) {
        let imageUrl = track.album?.cover[0].url ?? ""
        let finalImageUrl = imageUrl == "" ? thumbImage : imageUrl
        print(finalImageUrl)
        thumbImageView.setNetworkImage(urlString: finalImageUrl)
        artistLabel.text = track.artists[0].name
        nameLabel.text = track.name
    }
}
