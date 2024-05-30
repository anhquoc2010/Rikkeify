//
//  TrackViewVC.swift
//  Rikkeify
//
//  Created by QuocLA on 06/05/2024.
//

import AVFoundation
import SkeletonView
import DownloadButton

class TrackViewVC: UIViewController {
    // MARK: Properties
    private var viewModel: TrackViewVM
    private var isSliding: Bool = false
    private var isFetching: Bool = false
    
    // MARK: Outlets
    @IBOutlet private weak var downloadButton: PKDownloadButton!
    @IBOutlet private weak var lyricErrorLabel: UILabel!
    @IBOutlet private weak var likeButton: UIButton!
    @IBOutlet private weak var loopButton: UIButton!
    @IBOutlet private weak var shuffleButton: UIButton!
    @IBOutlet private weak var forwardButton: UIButton!
    @IBOutlet private weak var backwardButton: UIButton!
    @IBOutlet private weak var playPauseButton: UIButton!
    @IBOutlet private weak var lyricsTableView: UITableView!
    @IBOutlet private weak var lyricsView: UIView!
    @IBOutlet private weak var trackTimeSumOrRemainLabel: UILabel!
    @IBOutlet private weak var trackTimeNowLabel: UILabel!
    @IBOutlet private weak var trackProgressSlider: UISlider!
    @IBOutlet private weak var authorNameLabel: UILabel!
    @IBOutlet private weak var trackNameLabel: UILabel!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: Lifecycle
    init(trackId: String = "") {
        viewModel = TrackViewVM(trackId: trackId)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if viewModel.trackId.isEmpty {
            self.setupViews()
            self.setupEvents()
            self.bindViewModel()
            self.setupListViews()
        } else {
            self.showLoading()
            self.viewModel.playback.tracks = [Track(id: viewModel.trackId, name: "", shareUrl: "", durationMs: 0, durationText: "", trackNumber: nil, playCount: 0, artists: [], album: nil, lyrics: [], audio: [])]
            self.viewModel.playback.playerItems = [nil]
            self.viewModel.playback.playedIndex.removeAll()
            self.viewModel.playback.currentTrackIndex = 0
            self.viewModel.playback.player.pause()
            self.viewModel.playback.fetchTrackMetadata(index: 0) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                        guard let self = self else { return }
                        self.viewModel.playback.currentSectionContentId = ""
                        self.viewModel.playback.playTrack(index: 0)
                        self.setupViews()
                        self.setupEvents()
                        self.bindViewModel()
                        self.setupListViews()
                        self.hideLoading(after: 3)
                    }
                case .failure(let error):
                    self.hideLoading(after: 1.5)
                    self.showAlert(title: error.customMessage.capitalized, message: "")
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.observerPlayback()
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        super.remoteControlReceived(with: event)
        
        if let event = event {
            if event.type == .remoteControl {
                switch event.subtype {
                case .remoteControlNextTrack:
                    navigationController?.popViewController(animated: true)
                case .remoteControlPreviousTrack:
                    navigationController?.popViewController(animated: true)
                default:
                    break
                }
            }
        }
    }
    
    // MARK: - Actions
    @IBAction private func onHideButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func onShareButtonTapped(_ sender: Any) {
        let title: String = viewModel.playback.currentTrack.name
        guard let url: URL = URL(string: "https://0sfvs9d4-8100.asse.devtunnels.ms/\(viewModel.playback.currentTrack.id)") else { return }
        let sharedObjects: [AnyObject] = [url as AnyObject, title as AnyObject]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view

        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.airDrop,
            UIActivity.ActivityType.postToFacebook,
            UIActivity.ActivityType.postToTwitter,
            UIActivity.ActivityType.mail,
            UIActivity.ActivityType.copyToPasteboard,
            UIActivity.ActivityType.collaborationCopyLink,
            UIActivity.ActivityType.collaborationInviteWithLink,
            UIActivity.ActivityType.message,
        ]

        self.present(activityViewController, animated: true, completion: nil)
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
        updateLikeButton(sender)
    }
    
    @IBAction private func onQueueButtonTapped(_ sender: UIButton) {
        // TODO: Implement
        let vc = TrackListVC(sectionContent: SectionContent(type: "", id: viewModel.playback.currentSectionContentId, name: "", visuals: nil, images: nil))
        present(vc, animated: false)
    }
    
    @IBAction private func onForwardButtonTapped(_ sender: UIButton) {
        self.isFetching = true
        self.showLoading(text: "Fetching Audio")
        viewModel.playback.player.pause()
        viewModel.playback.playNextTrack(didTapForward: true) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                        guard let self = self else { return }
                        self.viewModel.playback.playTrack(index: self.viewModel.playback.currentTrackIndex)
                        self.isFetching = false
                        self.hideLoading(after: 3)
                        self.setBackFordwardStatus()
                        self.bindViewModel()
                    }
                case .failure(let error):
                    self.showAlert(title: error.customMessage.capitalized, message: "") {
                        if error == .getAudioError {
                            self.dismiss(animated: true)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction private func onBackwardButtonTapped(_ sender: UIButton) {
        self.isFetching = true
        self.showLoading(text: "Fetching Audio")
        viewModel.playback.player.pause()
        viewModel.playback.onPreviousTrack() { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                switch result {
                case .success:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
                        guard let self = self else { return }
                        self.viewModel.playback.playTrack(index: self.viewModel.playback.currentTrackIndex)
                        self.isFetching = false
                        self.hideLoading(after: 3)
                        self.setBackFordwardStatus()
                        self.bindViewModel()
                    }
                case .failure(let error):
                    self.showAlert(title: error.customMessage.capitalized, message: "") {
                        if error == .getAudioError {
                            self.dismiss(animated: true)
                        }
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            self.isSliding = false
        }
    }
    
    @IBAction func onTouchUpInsideSlider(_ sender: UISlider) {
        viewModel.playback.didSlideSlider(toTime: Double(sender.value))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
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
        
        cell.configure(lyric: viewModel.playback.currentTrack.lyrics[indexPath.row].text, color: .black)
        
        return cell
    }
}

extension TrackViewVC: PKDownloadButtonDelegate {
    func downloadButtonTapped(_ downloadButton: PKDownloadButton!, currentState state: PKDownloadButtonState) {
        switch state {
        case .startDownload:
            // Start the download
            viewModel.downloadOrRemoveTracks(progressHandler: { [weak self] progress in
                guard let self = self else { return }
                // Update UI with download progress
                DispatchQueue.main.async { [weak self] in
                    guard let _ = self else { return }
                    downloadButton.stopDownloadButton.progress = CGFloat(Float(progress))
                }
            }) { [weak self] result in
                // Handle download completion
                guard let self = self else { return }
                switch result {
                case .success:
                    // Set button state to downloaded when download is complete
                    DispatchQueue.main.async { [weak self] in
                        guard let _ = self else { return }
                        downloadButton.state = .downloaded
                    }
                case .failure(let error):
                    // Handle download failure
                    print("Download failed with error: \(error.localizedDescription)")
                }
            }
            // Set button state to downloading
            downloadButton.state = .downloading
        case .pending, .downloading:
            // Reset download when tapped in any of these states
            downloadButton.state = .startDownload
        case .downloaded:
            viewModel.downloadOrRemoveTracks(progressHandler: { [weak self] progress in
                guard let self = self else { return }
                // Update UI with download progress
                DispatchQueue.main.async { [weak self] in
                    guard let _ = self else { return }
                    downloadButton.stopDownloadButton.progress = CGFloat(Float(progress))
                }
            }) { [weak self] result in
                // Handle download completion
                guard let self = self else { return }
                switch result {
                case .success:
                    // Set button state to downloaded when download is complete
                    DispatchQueue.main.async { [weak self] in
                        guard let _ = self else { return }
                        downloadButton.state = .startDownload
                    }
                case .failure(let error):
                    // Handle download failure
                    print("Download failed with error: \(error.localizedDescription)")
                }
            }
        @unknown default:
            assertionFailure("Unsupported state")
        }
    }
}

// MARK: - Private Methods
extension TrackViewVC {
    private func setupViews() {
        downloadButton.delegate = self
        
        downloadButton.downloadedButton.cleanDefaultAppearance()
        downloadButton.downloadedButton.setImage(.init(systemName: IconSystem.downloaded.systemName()), for: .normal)
        downloadButton.downloadedButton.tintColor = .systemGreen
        downloadButton.downloadedButton.setTitle(nil, for: .normal)
        
        downloadButton.pendingView.tintColor = .systemGreen
        downloadButton.stopDownloadButton.tintColor = .systemGreen
        
        downloadButton.startDownloadButton.cleanDefaultAppearance()
        downloadButton.startDownloadButton.setImage(.init(systemName: IconSystem.startDownload.systemName()), for: .normal)
        downloadButton.startDownloadButton.tintColor = .white
        downloadButton.startDownloadButton.setTitle(nil, for: .normal)
        
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
        
        self.updateSliderAndLyric(time: viewModel.playback.player.currentTime())
        self.updatePlayPauseButton(playPauseButton)
        self.setBackFordwardStatus()
        self.viewModel.checkFavorite() { [weak self] _ in
            guard let self = self else { return }
            self.updateLikeButton(likeButton)
        }
        self.viewModel.checkDownload() { [weak self] _ in
            guard let self = self else { return }
            self.downloadButton.state = self.viewModel.isDownload ? .downloaded : .startDownload
        }
    }
    
    private func updateLyric(currentTime: CMTime) {
        let currentTimeInMs = Int(CMTimeGetSeconds(currentTime) * 1000)
        print("currentTime \(currentTimeInMs)")
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let indexPath = self.indexPathForTime(currentTimeInMs),
               indexPath.row < self.lyricsTableView.numberOfRows(inSection: 0) {
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
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.viewModel.playback.isFirstTrack && self.viewModel.playback.isLastTrack {
                self.backwardButton.isEnabled = false
                self.forwardButton.isEnabled = false
                self.shuffleButton.isEnabled = false
            } else if self.viewModel.playback.isFirstTrack {
                self.backwardButton.isEnabled = false
                self.forwardButton.isEnabled = true
                self.shuffleButton.isEnabled = true
            }  else if self.viewModel.playback.isLastTrack {
                self.backwardButton.isEnabled = true
                self.forwardButton.isEnabled = false
                self.shuffleButton.isEnabled = true
            } else {
                self.backwardButton.isEnabled = true
                self.forwardButton.isEnabled = true
                self.shuffleButton.isEnabled = true
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
                self.updateLyric(currentTime: time)
                self.updatePlayPauseButton(playPauseButton)
                self.setBackFordwardStatus()
                self.viewModel.checkFavorite() { [weak self] _ in
                    guard let self = self else { return }
                    self.updateLikeButton(likeButton)
                }
                self.viewModel.checkDownload() { [weak self] _ in
                    guard let self = self else { return }
                    self.downloadButton.state = self.viewModel.isDownload ? .downloaded : .startDownload
                }
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
