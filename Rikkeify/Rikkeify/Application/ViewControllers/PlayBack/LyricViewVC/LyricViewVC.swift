//
//  LyricViewVC.swift
//  Rikkeify
//
//  Created by QuocLA on 07/05/2024.
//

import UIKit

class LyricViewVC: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var artistsLabel: UILabel!
    @IBOutlet private weak var trackNameLabel: UILabel!
    @IBOutlet private weak var lyricsTableView: UITableView!
    @IBOutlet private weak var trackProgressSlider: UISlider!
    
    // MARK: - Properties
    private let viewModel: LyricViewVM
    
    // MARK: - Lifecycle
    init(track: Track) {
        self.viewModel = LyricViewVM(track: track)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupListViews()
        bindViewModel()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        setupViews()
    }
    
    // MARK: - Actions
    @IBAction private func onPlayPauseButtonTapped(_ sender: UIButton) {
        viewModel.togglePlayPauseState()
        updatePlayPauseButton(sender)
    }
    
    @IBAction private func onBackButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}

// MARK: - UITableViewDataSource
extension LyricViewVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.track.lyrics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = lyricsTableView
            .dequeueReusableCell(
                withIdentifier: "TrackViewLyricTableViewCell",
                for: indexPath
            ) as? TrackViewLyricTableViewCell
        else { return .init() }
        
        cell.configure(lyric: viewModel.track.lyrics[indexPath.row].text, color: .white)
        
        return cell
    }
}

// MARK: - Private methods
extension LyricViewVC {
    private func setupViews() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 14)
        let image = UIImage(systemName: "circle.fill", withConfiguration: configuration)
        trackProgressSlider.setThumbImage(image, for: .normal)
        
        lyricsTableView.showsVerticalScrollIndicator = false
    }
    
    private func setupListViews() {
        let nib = UINib(nibName: "TrackViewLyricTableViewCell", bundle: nil)
        lyricsTableView.register(nib, forCellReuseIdentifier: "TrackViewLyricTableViewCell")
        lyricsTableView.dataSource = self
    }
    
    private func bindViewModel() {
        trackNameLabel.text = viewModel.track.name
        artistsLabel.text = viewModel.track.artists[0].name
        
        lyricsTableView.reloadData()
    }
    
    private func updatePlayPauseButton(_ button: UIButton) {
        let imageName = viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill"
        let image = UIImage(systemName: imageName)
        button.setBackgroundImage(image, for: .normal)
    }
}
