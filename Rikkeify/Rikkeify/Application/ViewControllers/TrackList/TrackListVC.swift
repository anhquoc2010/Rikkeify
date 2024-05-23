//
//  TrackList.swift
//  Rikkeify
//
//  Created by PearUK on 14/5/24.
//

import UIKit
import SkeletonView
import AVFoundation
import DownloadButton

class TrackListVC: UIViewController {
    // MARK: Properties
    private var viewModel: TrackListVM
    
    // MARK: Outlets
    @IBOutlet private weak var typeLabel: UILabel!
    @IBOutlet private weak var loadingViewHC: NSLayoutConstraint!
    @IBOutlet private weak var loadingView: UIView!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var nameTableView: UILabel!
    @IBOutlet private weak var thumbImageView: UIImageView!
    @IBOutlet private weak var tracksTableView: IntrinsicTableView!
    
    // MARK: Lifecycle
    init(sectionContent: SectionContent) {
        viewModel = TrackListVM(sectionContent: sectionContent)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupListViews()
        bindViewModel()
        observerPlayback()
    }
    
    // MARK: Actions
    @IBAction func onBackButtonTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func onPlayButtonTapped(_ sender: UIButton) {
        if !viewModel.isPlayingThisSectionContent {
            self.showLoading(text: "Fetching track")
            viewModel.playback.player.pause()
        }
        viewModel.onTapPlayPauseButton { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.viewModel.playback.playTrack(index: self.viewModel.playback.currentTrackIndex)
                    self.hideLoading(after: 3)
                }
            case .failure(let error):
                self.hideLoading(after: 1.5)
                self.showAlert(title: error.customMessage.capitalized, message: "Fetch Lyric Failed")
                //                    self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

// MARK: UITableViewDataSource
extension TrackListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tracksTableView
            .dequeueReusableCell(
                withIdentifier: "TrackListTableViewCell",
                for: indexPath
            ) as? TrackListTableViewCell
        else { return .init() }
        
        cell.configure(track: viewModel.tracks[indexPath.row], thumbImage: viewModel.thumbImage)
        
        return cell
    }
}

// MARK: UITableViewDelegate
extension TrackListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if !viewModel.isPlayingThisSectionContent {
//            self.showLoading(text: "Fetching track")
//            viewModel.playback.player.pause()
//        }
//        viewModel.onTapPlayPauseButton(index: indexPath.row) { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success:
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    self.viewModel.playback.playTrack(index: self.viewModel.playback.currentTrackIndex)
//                    self.hideLoading(after: 3)
//                }
//            case .failure(let error):
//                self.hideLoading(after: 1.5)
//                self.showAlert(title: error.customMessage.capitalized, message: "Fetch Lyric Failed")
//                //                    self.navigationController?.popViewController(animated: true)
//            }
//        }
    }
}

// MARK: Custom Functions
extension TrackListVC {
    
    private func observerPlayback() {
        viewModel.playback.player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: .main) { [weak self] time in
            guard let self = self else { return }
            
            if viewModel.isPlayingThisSectionContent {
                self.updatePlayPauseButton(playButton)
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
    
    private func setupViews() {
        self.typeLabel.text = self.viewModel.sectionContent.type.capitalized
        self.nameTableView.text = self.viewModel.titleName
        self.loadingView.showAnimatedSkeleton()
        self.thumbImageView.setNetworkImage(urlString: self.viewModel.thumbImage)
    }
    
    private func setupListViews() {
        self.tracksTableView.register(UINib(nibName: "TrackListTableViewCell", bundle: nil), forCellReuseIdentifier: "TrackListTableViewCell")
        self.tracksTableView.dataSource = self
        self.tracksTableView.delegate = self
    }
    
    private func bindViewModel() {
        viewModel.fetchSectionContent { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.tracksTableView.reloadData()
                    self.loadingView.hideSkeleton()
                    self.loadingView.isHidden = true
                    self.loadingViewHC.constant = 0
                    self.playButton.isEnabled = !self.viewModel.tracks.isEmpty
                }
            case .failure(let error):
                self.showAlert(title: error.customMessage.capitalized, message: "") {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
