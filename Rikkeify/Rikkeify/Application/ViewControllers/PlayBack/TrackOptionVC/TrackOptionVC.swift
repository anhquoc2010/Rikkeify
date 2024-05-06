//
//  TrackOptionVC.swift
//  Rikkeify
//
//  Created by QuocLA on 06/05/2024.
//

import UIKit

class TrackOptionVC: UIViewController {
    @IBOutlet private weak var optionTableView: UITableView!
    @IBOutlet private weak var trackAuthorLabel: UILabel!
    @IBOutlet private weak var trackNameLabel: UILabel!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    
    private let viewModel: TrackOptionVM
    
    init(viewModel: TrackOptionVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
}

extension TrackOptionVC {
    private func setupViews() {
        thumbnailImageView.image = .init(named: viewModel.track.thumbnail)
        trackNameLabel.text = viewModel.track.name
        trackAuthorLabel.text = viewModel.track.author
    }
}
