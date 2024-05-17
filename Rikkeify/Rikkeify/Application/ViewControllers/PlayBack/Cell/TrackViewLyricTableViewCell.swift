//
//  TrackViewLyricTableViewCell.swift
//  Rikkeify
//
//  Created by QuocLA on 07/05/2024.
//

import UIKit

class TrackViewLyricTableViewCell: UITableViewCell {
    @IBOutlet weak var lyricLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configure(lyric: String, color: UIColor) {
        lyricLabel.text = lyric
        lyricLabel.textColor = color
    }
}
