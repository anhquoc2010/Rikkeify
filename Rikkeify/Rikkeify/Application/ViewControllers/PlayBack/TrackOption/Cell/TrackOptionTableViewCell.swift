//
//  TrackOptionTableViewCell.swift
//  Rikkeify
//
//  Created by QuocLA on 06/05/2024.
//

import UIKit

class TrackOptionTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleOptionLabel: UILabel!
    @IBOutlet private weak var iconOptionImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(option: TrackOption) {
        iconOptionImageView.image = .init(systemName: option.icon)
        titleOptionLabel.text = option.name
    }
}
