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
    
    @IBAction func onCloseButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
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
        setupListViews()
        bindViewModel()
    }
}

extension TrackOptionVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.optionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = optionTableView
            .dequeueReusableCell(
                withIdentifier: "TrackOptionTableViewCell",
                for: indexPath
            ) as? TrackOptionTableViewCell
        else { return .init() }
        
        cell.configure(option: viewModel.optionList[indexPath.row])
        
        return cell
    }
}

extension TrackOptionVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

extension TrackOptionVC {
    private func setupViews() {
        blurredBackgroundView(self.view)
    }
    
    private func setupListViews() {
        let nib = UINib(nibName: "TrackOptionTableViewCell", bundle: nil)
        optionTableView.register(nib, forCellReuseIdentifier: "TrackOptionTableViewCell")
        optionTableView.dataSource = self
        optionTableView.delegate = self
    }
    
    private func bindViewModel() {
        thumbnailImageView.image = .init(named: viewModel.track.thumbnail)
        trackNameLabel.text = viewModel.track.name
        trackAuthorLabel.text = viewModel.track.author
        
        viewModel.fetchOptions()
        optionTableView.reloadData()
    }
    
    private func blurredBackgroundView(_ view: UIView) {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let blurredView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        blurredView.frame = view.bounds
        view.insertSubview(blurredView, at: 0)
    }
}
