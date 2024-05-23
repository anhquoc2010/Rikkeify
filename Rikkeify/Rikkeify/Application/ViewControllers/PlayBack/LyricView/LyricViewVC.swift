//
//  LyricViewVC.swift
//  Rikkeify
//
//  Created by QuocLA on 07/05/2024.
//

import UIKit
import AVFoundation

class LyricViewVC: UIViewController {
    
    // MARK: - Properties
    private let viewModel: LyricViewVM
    private var isSliding: Bool = false
    
    // MARK: - Outlets
    @IBOutlet private weak var lyricErrorLabel: UILabel!
    @IBOutlet private weak var trackTimeSumOrRemainLabel: UILabel!
    @IBOutlet private weak var trackTimeNowLabel: UILabel!
    @IBOutlet private weak var playPauseButton: UIButton!
    @IBOutlet private weak var artistsLabel: UILabel!
    @IBOutlet private weak var trackNameLabel: UILabel!
    @IBOutlet private weak var lyricsTableView: UITableView!
    @IBOutlet private weak var trackProgressSlider: UISlider!
    
    // MARK: - Lifecycle
    init() {
        self.viewModel = LyricViewVM()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        bindViewModel()
        setupListViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        observerPlayback()
    }
    
    // MARK: - Actions
    @IBAction private func onPlayPauseButtonTapped(_ sender: UIButton) {
        viewModel.playback.togglePlayPauseState()
    }
    
    @IBAction func onBackButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
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
extension LyricViewVC: UITableViewDataSource {
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

// MARK: - Private methods
extension LyricViewVC {
    private func setupViews() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 14)
        let image = UIImage(systemName: IconSystem.sliderThumb.systemName(), withConfiguration: configuration)
        trackProgressSlider.setThumbImage(image, for: .normal)
        lyricsTableView.showsVerticalScrollIndicator = false
    }
    
    private func setupListViews() {
        let nib = UINib(nibName: "TrackViewLyricTableViewCell", bundle: nil)
        lyricsTableView.register(nib, forCellReuseIdentifier: "TrackViewLyricTableViewCell")
        lyricsTableView.dataSource = self
    }
    
    private func bindToViews() {
        let currentTrack = viewModel.playback.currentTrack
        self.trackNameLabel.text = currentTrack.name
        self.artistsLabel.text = currentTrack.artists.first?.name
        self.trackProgressSlider.maximumValue = Float(currentTrack.durationMs)
        self.lyricErrorLabel.isHidden = !currentTrack.lyrics.isEmpty
        
        self.updateSliderAndLyric(time: viewModel.playback.player.currentTime())
        self.updatePlayPauseButton(playPauseButton)
    }
    
    private func bindToListView() {
        self.lyricsTableView.reloadData()
        self.lyricsTableView.scrollsToTop = true
    }
    
    private func bindViewModel() {
        self.bindToViews()
        self.bindToListView()
    }
    
    private func observerPlayback() {
        let player = self.viewModel.playback.player
        player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: .main) { [weak self] time in
            guard let self = self else { return }
            
            self.updateSliderAndLyric(time: time)
            self.updateLyric(currentTime: time)
            self.updatePlayPauseButton(playPauseButton)
            self.bindToViews()
            if CMTimeGetSeconds(time) <= 1.5 {
                self.bindToListView()
            }
        }
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
    
    private func updateSliderAndLyric(time: CMTime) {
        
        if !self.isSliding {
            trackProgressSlider.setValue(Float(CMTimeGetSeconds(time) * 1000), animated: true)
            
            trackTimeNowLabel.text = millisecondsToMinutesSeconds(Int(trackProgressSlider.value))
            trackTimeSumOrRemainLabel.text = "-\(millisecondsToMinutesSeconds(Int(trackProgressSlider.maximumValue - trackProgressSlider.value)))"
        }
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
    
    private func millisecondsToMinutesSeconds(_ milliseconds: Int) -> String {
        let totalSeconds = milliseconds / 1000
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
