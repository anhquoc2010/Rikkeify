//
//  TrackViewVC.swift
//  Rikkeify
//
//  Created by QuocLA on 06/05/2024.
//

import UIKit

class TrackViewVC: UIViewController {
    // MARK: Outlets
    @IBOutlet private weak var lyricsTableView: UITableView!
    @IBOutlet private weak var lyricsView: UIView!
    @IBOutlet private weak var speakerButtonLabel: UILabel!
    @IBOutlet private weak var speakerButtonImageView: UIButton!
    @IBOutlet private weak var trackTimeSumOrRemainLabel: UILabel!
    @IBOutlet private weak var trackTimeNowLabel: UILabel!
    @IBOutlet private weak var trackProgressSlider: UISlider!
    @IBOutlet private weak var authorNameLabel: UILabel!
    @IBOutlet private weak var trackNameLabel: UILabel!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: Properties
    @Inject
    private var viewModel: TrackViewVM!
    
    private var timer: Timer?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.fetchTrackMetadata { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.setupViews()
                self.setupListViews()
                self.setupEvents()
                self.bindViewModel()
            case .failure(let error):
                print("error \(error)")
            }
        }
    }
    
    // MARK: - Actions
    @IBAction private func onHideButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction private func onLoopButtonTapped(_ sender: UIButton) {
        viewModel.toggleLoopState()
        updateLoopButton(sender)
    }
    
    @IBAction private func onPlayPauseButtonTapped(_ sender: UIButton) {
        viewModel.togglePlayPauseState()
        updatePlayPauseButton(sender)
    }
    
    @IBAction private func onShuffleButtonTapped(_ sender: UIButton) {
        viewModel.toggleShuffleState()
        updateShuffleButton(sender)
    }
    
    @IBAction private func onLikeButtonTapped(_ sender: UIButton) {
        viewModel.toggleLikeState()
        updateLikeButton(sender)
    }
    
    @IBAction private func onShowMoreLyricsButtonTapped(_ sender: UIButton) {
        // TODO: Implement
    }
    
    @IBAction private func onQueueButtonTapped(_ sender: UIButton) {
        // TODO: Implement
    }
    
    @IBAction private func onShareButtonTapped(_ sender: UIButton) {
        // TODO: Implement
    }
    
    @IBAction private func onSpeakerButtonTapped(_ sender: UIButton) {
        // TODO: Implement
    }
    
    @IBAction private func onForwardButtonTapped(_ sender: UIButton) {
        // TODO: Implement
    }
    
    @IBAction private func onBackwardButtonTapped(_ sender: UIButton) {
        // TODO: Implement
    }
    
    @IBAction private func onActionButtonTapped(_ sender: UIButton) {
        let vc = TrackOptionVC(viewModel: TrackOptionVM(track: viewModel.track!))
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension TrackViewVC: UITableViewDataSource {
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
        
        cell.configure(lyric: viewModel.track.lyrics[indexPath.row].text, color: .black)
        
        return cell
    }
}

// MARK: - Private Methods
extension TrackViewVC {
    private func setupViews() {
        titleLabel.text = viewModel.track.album.name
        thumbnailImageView.setImage(from: viewModel.track.album.cover[0].url)
        trackNameLabel.text = viewModel.track.name
        authorNameLabel.text = viewModel.track.artists[0].name
        trackProgressSlider.maximumValue = Float(viewModel.track.durationMs)
        trackTimeSumOrRemainLabel.text = "-\(viewModel.track.durationText)"
        let configuration = UIImage.SymbolConfiguration(pointSize: 14)
        let image = UIImage(systemName: "circle.fill", withConfiguration: configuration)
        trackProgressSlider.setThumbImage(image, for: .normal)
    }
    
    private func setupListViews() {
        let nib = UINib(nibName: "TrackViewLyricTableViewCell", bundle: nil)
        lyricsTableView.register(nib, forCellReuseIdentifier: "TrackViewLyricTableViewCell")
        lyricsTableView.dataSource = self
    }
    
    private func setupEvents() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(lyricsViewTapped))
        lyricsView.addGestureRecognizer(tapGesture)
    }
    
    private func bindViewModel() {
        lyricsTableView.reloadData()
    }
    
    private func updateLoopButton(_ button: UIButton) {
        let imageName: String
        switch viewModel.loopState {
        case .none:
            imageName = "repeat"
        case .loop:
            imageName = "repeat"
        case .loopOne:
            imageName = "repeat.1"
        }
        let image = UIImage(systemName: imageName)
        let color: UIColor = viewModel.loopState != .none ? .systemGreen : .white
        button.setImage(image, for: .normal)
        button.tintColor = color
    }
    
    private func updatePlayPauseButton(_ button: UIButton) {
        let imageName = viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill"
        let image = UIImage(systemName: imageName)
        button.setBackgroundImage(image, for: .normal)
        
        if viewModel.isPlaying {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        } else {
            timer?.invalidate()
        }
    }
    
    private func updateShuffleButton(_ button: UIButton) {
        let color: UIColor = viewModel.isShuffled ? .systemGreen : .white
        button.tintColor = color
    }
    
    private func updateLikeButton(_ button: UIButton) {
        let imageName = viewModel.isLiked ? "heart.fill" : "heart"
        let image = UIImage(systemName: imageName)
        button.setImage(image, for: .normal)
        let color: UIColor = viewModel.isLiked ? .systemGreen : .white
        button.tintColor = color
    }
    
    private func millisecondsToMinutesSeconds(_ milliseconds: Int) -> String {
        let totalSeconds = milliseconds / 1000
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Private @objc Methods
extension TrackViewVC {
    @objc private func lyricsViewTapped() {
        let vc = LyricViewVC(viewModel: LyricViewVM(track: viewModel.track))
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @objc func updateSlider() {
        trackProgressSlider.setValue(trackProgressSlider.value + 1000, animated: true)
        trackTimeNowLabel.text = millisecondsToMinutesSeconds(Int(trackProgressSlider.value))
        trackTimeSumOrRemainLabel.text = "-\(millisecondsToMinutesSeconds(Int(trackProgressSlider.maximumValue - trackProgressSlider.value)))"
        
        if trackProgressSlider.value >= trackProgressSlider.maximumValue {
            trackProgressSlider.setValue(0, animated: true)
        }
    }
}
