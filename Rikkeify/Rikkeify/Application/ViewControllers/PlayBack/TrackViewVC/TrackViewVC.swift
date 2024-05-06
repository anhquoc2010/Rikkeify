//
//  TrackViewVC.swift
//  Rikkeify
//
//  Created by QuocLA on 06/05/2024.
//

import UIKit

class TrackViewVC: UIViewController {
    // MARK: Outlets
    @IBOutlet private weak var trackLyricsLabel: UILabel!
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
    private let viewModel: TrackViewVM
    
    init(viewModel: TrackViewVM) {
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
        // TODO: Implement
        present(TrackOptionVC(viewModel: TrackOptionVM(track: viewModel.track)), animated: true)
    }
}

extension TrackViewVC {
    // MARK: - Private Methods
    private func setupViews() {
        let configuration = UIImage.SymbolConfiguration(pointSize: 14)
        let image = UIImage(systemName: "circle.fill", withConfiguration: configuration)
        trackProgressSlider.setThumbImage(image, for: .normal)
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
}
