//
//  TrackViewVC.swift
//  Rikkeify
//
//  Created by QuocLA on 06/05/2024.
//

import AVFoundation
import SkeletonView

class TrackViewVC: UIViewController {
    // MARK: Outlets
    @IBOutlet private weak var playPauseButton: UIButton!
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
    private var viewModel: TrackViewVM
    
    // MARK: Lifecycle
    init(trackId: String) {
        viewModel = TrackViewVM(trackId: trackId)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        self.setupEvents()
        self.bindViewModel()
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
        let vc = TrackOptionVC(track: viewModel.track!)
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @IBAction func onSliderSlided(_ sender: UISlider) {
        viewModel.didSlideSlider(toTime: Double(sender.value))
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
        showSkeleton(views: titleLabel,
                     thumbnailImageView,
                     trackNameLabel,
                     authorNameLabel,
                     trackTimeNowLabel,
                     trackTimeSumOrRemainLabel,
                     lyricsView)
        let configuration = UIImage.SymbolConfiguration(pointSize: 14)
        let image = UIImage(systemName: "circle.fill", withConfiguration: configuration)
        trackProgressSlider.setThumbImage(image, for: .normal)
    }
    
    private func showSkeleton(views: UIView...) {
        views.forEach { $0.showAnimatedSkeleton() }
    }
    
    private func hideSkeleton(views: UIView...) {
        views.forEach { $0.hideSkeleton() }
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
        viewModel.fetchTrackMetadata { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                self.hideSkeleton(views: titleLabel,
                                  thumbnailImageView,
                                  trackNameLabel,
                                  authorNameLabel,
                                  trackTimeNowLabel,
                                  trackTimeSumOrRemainLabel,
                                  lyricsView)
                
                self.titleLabel.text = viewModel.track.album.name
                self.thumbnailImageView.setImage(from: viewModel.track.album.cover[0].url)
                self.trackNameLabel.text = viewModel.track.name
                self.authorNameLabel.text = viewModel.track.artists[0].name
                self.trackProgressSlider.maximumValue = Float(viewModel.track.durationMs)
                self.trackTimeSumOrRemainLabel.text = "-\(viewModel.track.durationText)"
                
                self.setupListViews()
                self.lyricsTableView.reloadData()
                
                self.viewModel.startPlayback(audioTrack: viewModel.track.audio[0])
                
                self.viewModel.player?
                    .addPeriodicTimeObserver(
                        forInterval: CMTimeMake(value: 1, timescale: 1),
                        queue: .main) { [weak self] time in
                            guard let self = self else { return }
                            self.updateSlider(time: time)
                            self.updatePlayPauseButton(playPauseButton)
                        }
            case .failure(let error):
                print("error \(error)")
            }
        }
    }
    
    func updateSlider(time: CMTime) {
        guard let player = viewModel.player else { return }
        
        trackProgressSlider.setValue(Float(player.currentTime().seconds * 1000), animated: true)
        
        if trackProgressSlider.value >= trackProgressSlider.maximumValue {
            trackProgressSlider.value = 0
            viewModel.didSlideSlider(toTime: 0)
        }
        
        trackTimeNowLabel.text = millisecondsToMinutesSeconds(Int(trackProgressSlider.value))
        trackTimeSumOrRemainLabel.text = "-\(millisecondsToMinutesSeconds(Int(trackProgressSlider.maximumValue - trackProgressSlider.value)))"
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
        if let playerStatus = viewModel.player?.timeControlStatus {
            var imageName = "play.circle.fill"
            
            switch playerStatus {
            case .paused:
                imageName = "play.circle.fill"
            case .waitingToPlayAtSpecifiedRate:
                imageName = "play.circle.fill"
            case .playing:
                imageName = "pause.circle.fill"
            @unknown default:
                imageName = "play.circle.fill"
            }
            
            let image = UIImage(systemName: imageName)
            button.setBackgroundImage(image, for: .normal)
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
        let vc = LyricViewVC(track: viewModel.track)
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
}
