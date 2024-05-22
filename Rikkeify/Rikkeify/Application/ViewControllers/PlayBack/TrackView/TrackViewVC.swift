//
//  TrackViewVC.swift
//  Rikkeify
//
//  Created by QuocLA on 06/05/2024.
//

import AVFoundation
import SkeletonView

class TrackViewVC: UIViewController {
    // MARK: Properties
    private var viewModel: TrackViewVM
    private var isSliding: Bool = false
    private var isFetching: Bool = false
    
    // MARK: Outlets
    @IBOutlet private weak var lyricErrorLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var loopButton: UIButton!
    @IBOutlet private weak var shuffleButton: UIButton!
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
    
    // MARK: Lifecycle
    init() {
        viewModel = TrackViewVM()
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
        self.setupListViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.observerPlayback()
    }
    
    // MARK: - Actions
    @IBAction private func onHideButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction private func onLoopButtonTapped(_ sender: UIButton) {
        viewModel.playback.toggleLoopState()
        updateLoopButton(sender)
    }
    
    @IBAction private func onPlayPauseButtonTapped(_ sender: UIButton) {
        viewModel.playback.togglePlayPauseState()
    }
    
    @IBAction private func onShuffleButtonTapped(_ sender: UIButton) {
        viewModel.playback.toggleShuffleState()
        updateShuffleButton(sender)
    }
    
    @IBAction private func onLikeButtonTapped(_ sender: UIButton) {
        viewModel.saveOrRemoveFavourite()
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
        self.isFetching = true
        self.showLoading(text: "Fetching Audio")
        viewModel.playback.playNextTrack(didTapForward: true) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.viewModel.playback.playTrack(index: self.viewModel.playback.currentTrackIndex)
                    self.isFetching = false
                    self.hideLoading()
                    self.setBackFordwardStatus()
                    self.bindViewModel()
                case .failure(let error):
                    self.showAlert(title: error.customMessage.capitalized, message: "") {
//                        self.dismiss(animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction private func onBackwardButtonTapped(_ sender: UIButton) {
        self.isFetching = true
        self.showLoading(text: "Fetching Audio")
        viewModel.playback.onPreviousTrack() { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success:
                    self.viewModel.playback.playTrack(index: self.viewModel.playback.currentTrackIndex)
                    self.isFetching = false
                    self.hideLoading()
                    self.setBackFordwardStatus()
                    self.bindViewModel()
                case .failure(let error):
                    self.showAlert(title: error.customMessage.capitalized, message: "") {
//                        self.dismiss(animated: true)
                    }
                }
            }
        }
    }
    
    @IBAction private func onActionButtonTapped(_ sender: UIButton) {
        let vc = TrackOptionVC(track: viewModel.playback.currentTrack)
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    @IBAction func onTouchDownSlider(_ sender: Any) {
        isSliding = true
    }
    
    @IBAction func onTouchUpOutsideSlider(_ sender: UISlider) {
        viewModel.playback.didSlideSlider(toTime: Double(sender.value))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isSliding = false
        }
    }
    
    @IBAction func onTouchUpInsideSlider(_ sender: UISlider) {
        viewModel.playback.didSlideSlider(toTime: Double(sender.value))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.isSliding = false
        }
    }
}

// MARK: - UITableViewDataSource
extension TrackViewVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.playback.currentTrack.lyrics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = lyricsTableView
            .dequeueReusableCell(
                withIdentifier: "TrackViewLyricTableViewCell",
                for: indexPath
            ) as? TrackViewLyricTableViewCell
        else { return .init() }
        
        cell.configure(lyric: viewModel.playback.tracks[viewModel.playback.currentTrackIndex].lyrics[indexPath.row].text, color: .black)
        
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
        self.bindToViews()
        self.bindToListView()
    }
    
    private func updateLyric(currentTime: CMTime) {
        let currentTimeInMs = Int(CMTimeGetSeconds(currentTime) * 1000)
        print("currentTime \(currentTimeInMs)")

        DispatchQueue.main.async {
            if let indexPath = self.indexPathForTime(currentTimeInMs) {
                for row in 0..<self.viewModel.playback.currentTrack.lyrics.count {
                    if let cell = self.lyricsTableView.cellForRow(at: IndexPath(row: row, section: 0)) as? TrackViewLyricTableViewCell {
                        cell.lyricLabel.textColor = (row <= indexPath.row) ? .white : .black
                    }
                }
                self.lyricsTableView.scrollToRow(at: indexPath, at: .middle, animated: true)
            }
        }
    }

    private func indexPathForTime(_ timeMs: Int) -> IndexPath? {
        for (index, lyric) in viewModel.playback.currentTrack.lyrics.enumerated() {
            let endTime = lyric.startMs + lyric.durMs
            print("Checking lyric at index \(index) with startTime \(lyric.startMs) and endTime \(endTime)")
            if timeMs >= lyric.startMs && timeMs <= endTime {
                return IndexPath(row: index, section: 0)
            }
        }
        return nil
    }

    private func setBackFordwardStatus() {
        DispatchQueue.main.async {
            if self.viewModel.playback.isFirstTrack {
                self.backwardButton.isEnabled = false
                self.forwardButton.isEnabled = true
            } else if self.viewModel.playback.isLastTrack {
                self.backwardButton.isEnabled = true
                self.forwardButton.isEnabled = false
            } else {
                self.backwardButton.isEnabled = true
                self.forwardButton.isEnabled = true
            }
        }
    }
    
    private func bindToViews() {
        self.hideSkeleton(views: titleLabel,
                          thumbnailImageView,
                          trackNameLabel,
                          authorNameLabel,
                          trackTimeNowLabel,
                          trackTimeSumOrRemainLabel,
                          lyricsView)
        
        let currentTrack = viewModel.playback.currentTrack
        self.titleLabel.text = currentTrack.album?.name ?? ""
        self.thumbnailImageView.setNetworkImage(urlString: currentTrack.album?.cover.first?.url ?? "")
        self.trackNameLabel.text = currentTrack.name
        self.authorNameLabel.text = currentTrack.artists.first?.name
        self.trackProgressSlider.maximumValue = Float(currentTrack.durationMs)
        self.lyricErrorLabel.isHidden = !currentTrack.lyrics.isEmpty
        self.updateLoopButton(loopButton)
        self.updateShuffleButton(shuffleButton)
        self.updateLikeButton(likeButton)
        self.setBackFordwardStatus()
    }
    
    private func bindToListView() {
        self.lyricsTableView.reloadData()
        self.lyricsTableView.scrollsToTop = true
    }
    
    private func observerPlayback() {
        let player = self.viewModel.playback.player
        player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: .main) { [weak self] time in
            guard let self = self else { return }
            if !isFetching {
                self.updateSliderAndLyric(time: time)
                self.updatePlayPauseButton(playPauseButton)
                self.updateLikeButton(likeButton)
                self.bindToViews()
                if CMTimeGetSeconds(time) <= 1.5 {
                    self.bindToListView()
                }
            }
        }
    }
    
    private func updateSliderAndLyric(time: CMTime) {
        
        if !self.isSliding {
            trackProgressSlider.setValue(Float(CMTimeGetSeconds(time) * 1000), animated: true)
            
            trackTimeNowLabel.text = millisecondsToMinutesSeconds(Int(trackProgressSlider.value))
            trackTimeSumOrRemainLabel.text = "-\(millisecondsToMinutesSeconds(Int(trackProgressSlider.maximumValue - trackProgressSlider.value)))"
        }
        
        updateLyric(currentTime: time)
    }
    
    private func updateLoopButton(_ button: UIButton) {
        let imageName: String
        switch viewModel.playback.loopState {
        case .none:
            imageName = IconSystem.loop.systemName()
        case .loop:
            imageName = IconSystem.loop.systemName()
        case .loopOne:
            imageName = IconSystem.loopOne.systemName()
        }
        let image = UIImage(systemName: imageName)
        let color: UIColor = viewModel.playback.loopState != .none ? .systemGreen : .white
        button.setImage(image, for: .normal)
        button.tintColor = color
    }
    
    private func updatePlayPauseButton(_ button: UIButton) {
        let playerStatus = viewModel.playback.player.timeControlStatus
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
    
    private func updateShuffleButton(_ button: UIButton) {
        let color: UIColor = viewModel.playback.isShuffled ? .systemGreen : .white
        button.tintColor = color
    }
    
    private func updateLikeButton(_ button: UIButton) {
        let imageName = viewModel.isFavorite ? IconSystem.liked.systemName() : IconSystem.like.systemName()
        let image = UIImage(systemName: imageName)
        button.setImage(image, for: .normal)
        let color: UIColor = viewModel.isFavorite ? .systemGreen : .white
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
        if !viewModel.playback.currentTrack.lyrics.isEmpty {
            let vc = LyricViewVC()
            vc.modalPresentationStyle = .overFullScreen
            present(vc, animated: true)
        }
    }
}
