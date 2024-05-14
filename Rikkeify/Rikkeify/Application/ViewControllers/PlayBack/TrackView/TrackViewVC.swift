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
    
    @IBOutlet private weak var forwardButton: UIButton!
    @IBOutlet private weak var backwardButton: UIButton!
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
    init(tracks: [Track]) {
        viewModel = TrackViewVM(tracks: tracks)
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
        viewModel.didTapForward {
            self.setBackFordwardStatus()
            self.bindViewModel()
        }
    }
    
    @IBAction private func onBackwardButtonTapped(_ sender: UIButton) {
        viewModel.didTapBackward() {
            self.setBackFordwardStatus()
            self.bindViewModel()
        }
    }
    
    @IBAction private func onActionButtonTapped(_ sender: UIButton) {
        let vc = TrackOptionVC(track: viewModel.tracks[viewModel.currentTrackIndex])
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
        viewModel.tracks[viewModel.currentTrackIndex].lyrics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = lyricsTableView
            .dequeueReusableCell(
                withIdentifier: "TrackViewLyricTableViewCell",
                for: indexPath
            ) as? TrackViewLyricTableViewCell
        else { return .init() }
        
        cell.configure(lyric: viewModel.tracks[viewModel.currentTrackIndex].lyrics[indexPath.row].text, color: .black)
        
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
        let image = UIImage(systemName: IconSystem.sliderThumb.systemName(), withConfiguration: configuration)
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
        if viewModel.isFirstLoad {
            bindViewModelFirstLoad()
        } else if viewModel.currentTrackIndex == viewModel.playerItems.count - 1 {
            bindViewModelLastReadyItem()
//        } else if viewModel.currentTrackIndex == viewModel.recommendTracks.count {
//            bindViewModelLastRecommendItem()
        } else {
            bindViewModelNormal()
        }
    }
    
    private func setBackFordwardStatus() {
        DispatchQueue.main.async {
            if self.viewModel.isFirstLoad || self.viewModel.isFirstTrack {
                self.backwardButton.isEnabled = false
                self.forwardButton.isEnabled = true
            } else if self.viewModel.currentTrackIndex == self.viewModel.playerItems.count - 1 {
                self.backwardButton.isEnabled = true
                self.forwardButton.isEnabled = false
//            } else if self.viewModel.currentTrackIndex == self.viewModel.recommendTracks.count {
//                self.backwardButton.isEnabled = true
//                self.forwardButton.isEnabled = false
            } else {
                self.backwardButton.isEnabled = true
                self.forwardButton.isEnabled = true
            }
        }
    }
    
//    private func bindViewModelLastRecommendItem() {
//        viewModel.fetchRecommendTracks { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success:
//                DispatchQueue.main.async {
//                    self.backwardButton.isEnabled = !self.viewModel.isFirstTrack
//                }
//                viewModel.preFetchNextTrackMetadata { [weak self] result in
//                    guard let self = self else { return }
//                    switch result {
//                    case .success:
//                        DispatchQueue.main.async {
//                            self.forwardButton.isEnabled = !self.viewModel.isLastTrack
//                        }
//                    case .failure:
//                        DispatchQueue.main.async {
//                            self.forwardButton.isEnabled = false
//                        }
//                    }
//                }
//            case .failure:
//                DispatchQueue.main.async {
//                    self.backwardButton.isEnabled = false
//                }
//            }
//        }
//        bindViewModelNormal()
//    }
    
    private func bindViewModelLastReadyItem() {
        viewModel.fetchTrackMetadata(index: viewModel.currentTrackIndex + 1) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.forwardButton.isEnabled = !self.viewModel.isLastTrack
                }
            case .failure:
                DispatchQueue.main.async {
                    self.forwardButton.isEnabled = false
                }
            }
        }
        bindViewModelNormal()
    }
    
    private func bindViewModelFirstLoad() {
        viewModel.fetchTrackMetadata(index: viewModel.currentTrackIndex) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                viewModel.isFirstLoad = false
                DispatchQueue.main.async {
                    self.backwardButton.isEnabled = !self.viewModel.isFirstTrack
                }
                
                viewModel.fetchTrackMetadata(index: viewModel.currentTrackIndex + 1) { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success:
                        DispatchQueue.main.async {
                            self.forwardButton.isEnabled = !self.viewModel.isLastTrack
                        }
                    case .failure:
                        DispatchQueue.main.async {
                            self.forwardButton.isEnabled = false
                        }
                    }
                }
//                viewModel.fetchRecommendTracks { [weak self] result in
//                    guard let self = self else { return }
//                    switch result {
//                    case .success:
//                        DispatchQueue.main.async {
//                            self.backwardButton.isEnabled = !self.viewModel.isFirstTrack
//                        }
//                        viewModel.preFetchNextTrackMetadata { [weak self] result in
//                            guard let self = self else { return }
//                            switch result {
//                            case .success:
//                                DispatchQueue.main.async {
//                                    self.forwardButton.isEnabled = !self.viewModel.isLastTrack
//                                }
//                            case .failure:
//                                DispatchQueue.main.async {
//                                    self.forwardButton.isEnabled = false
//                                }
//                            }
//                        }
//                    case .failure:
//                        DispatchQueue.main.async {
//                            self.backwardButton.isEnabled = false
//                        }
//                    }
//                }
                
                bindViewModelNormal()
                
                self.viewModel.startPlayback()
                
                if let player = self.viewModel.player {
                    player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: .main) { [weak self] time in
                        guard let self = self else { return }
                        self.updateSlider(time: time)
                        self.updatePlayPauseButton(playPauseButton)
                    }
                }
            case .failure(let error):
                print("error \(error)")
            }
        }
    }
    
    private func bindViewModelNormal() {
        self.setupListViews()
        self.bindToViews()
    }
    
    private func bindToViews() {
        self.hideSkeleton(views: titleLabel,
                          thumbnailImageView,
                          trackNameLabel,
                          authorNameLabel,
                          trackTimeNowLabel,
                          trackTimeSumOrRemainLabel,
                          lyricsView)
        
        let currentTrack = viewModel.tracks[viewModel.currentTrackIndex]
        print("===========================\n\(currentTrack)\n=========================")
        self.titleLabel.text = currentTrack.album?.name ?? ""
        self.thumbnailImageView.setNetworkImage(urlString: currentTrack.album?.cover[0].url ?? "")
        self.trackNameLabel.text = currentTrack.name
        self.authorNameLabel.text = currentTrack.artists[0].name
        self.trackProgressSlider.maximumValue = Float(currentTrack.durationMs)
        self.trackTimeSumOrRemainLabel.text = "-\(currentTrack.durationText)"
        
        self.lyricsTableView.reloadData()
    }
    
    private func updateSlider(time: CMTime) {
        if let player = viewModel.player {
            trackProgressSlider.setValue(Float(player.currentTime().seconds * 1000), animated: true)
        }
        
        if trackProgressSlider.value >= trackProgressSlider.maximumValue {
            trackProgressSlider.value = 0
            viewModel.didTapBackward() {
                self.setupViews()
                self.bindToViews()
            }
        }
        
        trackTimeNowLabel.text = millisecondsToMinutesSeconds(Int(trackProgressSlider.value))
        trackTimeSumOrRemainLabel.text = "-\(millisecondsToMinutesSeconds(Int(trackProgressSlider.maximumValue - trackProgressSlider.value)))"
    }
    
    private func updateLoopButton(_ button: UIButton) {
        let imageName: String
        switch viewModel.loopState {
        case .none:
            imageName = IconSystem.loop.systemName()
        case .loop:
            imageName = IconSystem.loop.systemName()
        case .loopOne:
            imageName = IconSystem.loopOne.systemName()
        }
        let image = UIImage(systemName: imageName)
        let color: UIColor = viewModel.loopState != .none ? .systemGreen : .white
        button.setImage(image, for: .normal)
        button.tintColor = color
    }
    
    private func updatePlayPauseButton(_ button: UIButton) {
        if let playerStatus = viewModel.player?.timeControlStatus {
            var imageName = IconSystem.play.systemName()
            
            switch playerStatus {
            case .paused:
                imageName = IconSystem.play.systemName()
            case .waitingToPlayAtSpecifiedRate:
                imageName = IconSystem.play.systemName()
            case .playing:
                imageName = IconSystem.pause.systemName()
            @unknown default:
                imageName = IconSystem.play.systemName()
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
        let imageName = viewModel.isLiked ? IconSystem.liked.systemName() : IconSystem.liked.systemName()
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
        let vc = LyricViewVC(track: viewModel.tracks[viewModel.currentTrackIndex])
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
}

extension TrackViewVC {
    enum IconSystem {
        case sliderThumb, loop, loopOne, play, pause, like, liked
        
        func systemName() -> String {
            switch self {
            case .sliderThumb:
                return "circle.fill"
            case .loop:
                return "repeat"
            case .loopOne:
                return "repeat.1"
            case .play:
                return "play.circle.fill"
            case .pause:
                return "pause.circle.fill"
            case .like:
                return "heart"
            case .liked:
                return "heart.fill"
            }
        }
    }
}
