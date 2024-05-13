//
//  HomeTableHeaderView.swift
//  Rikkeify
//
//  Created by PearUK on 13/5/24.
//

import UIKit

class HomeTableHeaderView: UITableViewHeaderFooterView {

    @IBOutlet private weak var titleSectionLabel: UILabel!
    
    func configure(title: String) {
        titleSectionLabel.text = title
    }
}
