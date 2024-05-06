//
//  TrackOptionTableViewCell.swift
//  Rikkeify
//
//  Created by QuocLA on 06/05/2024.
//

import UIKit

struct Option {
    let icon: String
    let title: String
}

class TrackOptionTableViewCell: UITableViewCell {
    @IBOutlet private weak var titleOptionLabel: UILabel!
    @IBOutlet private weak var iconOptionImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(option: Option) {
        iconOptionImageView.image = .init(named: option.icon)
        titleOptionLabel.text = option.title
    }
}
