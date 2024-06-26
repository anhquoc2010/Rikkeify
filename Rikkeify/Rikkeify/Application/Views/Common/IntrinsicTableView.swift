//
//  IntrinsicTableView.swift
//  Rikkeify
//
//  Created by QuocLA on 07/05/2024.
//

import UIKit

class IntrinsicTableView: UITableView {
    override var contentSize: CGSize {
        didSet {
            self.invalidateIntrinsicContentSize()
        }
    }

    override var intrinsicContentSize: CGSize {
        self.layoutIfNeeded()
        return CGSize(width: UIView.noIntrinsicMetric, height: contentSize.height)
    }
}
