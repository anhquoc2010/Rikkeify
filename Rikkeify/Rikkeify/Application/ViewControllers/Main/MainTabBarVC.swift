//
//  MainTabBarVC.swift
//  Rikkeify
//
//  Created by PearUK on 15/5/24.
//

import UIKit
import AVFoundation

private let kDefaultTabBarHeight = 49
private let kVerticalSpacing = 8
private let kMiniPlaybackHeight = 60
private let kBottomSafeArea = 34

class MainTabBarVC: UITabBarController {
    
    // MARK: Properties
    @Inject
    private var playback: PlaybackPresenter
    private var miniPlayBack: MiniPlaybackView!
    
    static let maxHeight = kDefaultTabBarHeight + kVerticalSpacing + kMiniPlaybackHeight + kBottomSafeArea
    static let minHeight = kDefaultTabBarHeight
    static var tabbarHeight = maxHeight
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBar()
        bindMiniPlaybackView()
        observerPlayer()
        hideCustomTabBarFrame()
    }
}

// MARK: Private methods
extension MainTabBarVC {
    
    private func hideCustomTabBarFrame() {
        MainTabBarVC.tabbarHeight = MainTabBarVC.maxHeight
        miniPlayBack.hideCustomView()
    }
    
    private func observerPlayer() {
        playback.player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: .main) { [weak self] time in
            guard let self = self else { return }
            
            self.updatePlayPauseButton(miniPlayBack.playPauseButton)
            let duration = CMTimeGetSeconds(playback.player.currentItem?.duration ?? CMTime(seconds: 0, preferredTimescale: 1))
            let currentTime = CMTimeGetSeconds(time)
            
            if currentTime >= duration - 0.5 {
                self.showLoading(text: "Fetching audio")
                playback.playNextTrack { [weak self] result in
                    guard let self = self else { return }
                    switch result {
                    case .success:
                        self.playback.playTrack(index: self.playback.currentTrackIndex)
                        self.hideLoading(after: 1)
                    case .failure(let error):
                        self.showAlert(title: error.customMessage.capitalized, message: "")
                    }
                }
            }
            
            self.miniPlayBack.trackProgressView.setProgress(Float(currentTime / duration), animated: false)
        }
    }
    
    private func bindMiniPlaybackView() {
        miniPlayBack = MiniPlaybackView(copyWith: tabBar)
        miniPlayBack.miniPlaybackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onTapCustomView(_:))))
        miniPlayBack.delegate = self
        miniPlayBack.tabBar.delegate = self
        
        view.addSubview(miniPlayBack)
    }
    
    private func setupTabBar() {
        let homeVC = HomeVC()
        let searchVC = UIViewController()
        let yourLibraryVC = UIViewController()

        let homeNavi = makeNavigationController(rootViewController: homeVC, tabTitle: "Home", tabImage: .icHome, selectedTabImage: .icHomeActivated)
        let searchNavi = makeNavigationController(rootViewController: searchVC, tabTitle: "Search", tabImage: .icSearch, selectedTabImage: .icSearchActivated)
        let yourLibraryNavi = makeNavigationController(rootViewController: yourLibraryVC, tabTitle: "Your Library", tabImage: .icYourLibrary, selectedTabImage: .icYourLibraryActivated)

        viewControllers = [homeNavi, searchNavi, yourLibraryNavi]
        
        tabBar.isTranslucent = false
        tabBar.tintColor = .white
        tabBar.standardAppearance.shadowColor = nil
        tabBar.standardAppearance.shadowImage = nil
        tabBar.standardAppearance.backgroundEffect = nil
        tabBar.standardAppearance.backgroundColor = nil
        tabBar.isHidden = true
    }
    
    private func updateSelectedViewControllerLayout() {
        tabBar.sizeToFit()
        miniPlayBack.sizeToFit()
        view.setNeedsLayout()
        view.layoutIfNeeded()
        viewControllers?[self.selectedIndex].view.setNeedsLayout()
        viewControllers?[self.selectedIndex].view.layoutIfNeeded()
    }
    
    private func makeNavigationController(rootViewController: UIViewController, tabTitle: String, tabImage: UIImage, selectedTabImage: UIImage) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.tabBarItem = UITabBarItem(title: tabTitle, image: tabImage, selectedImage: selectedTabImage)
        navigationController.navigationBar.isHidden = true
        return navigationController
    }
    
    @objc private func onTapCustomView(_ sender: UITapGestureRecognizer? = nil) {
        miniPlayBack.onTapCustomView(sender)
    }
    
    @objc private func updateTrackInfo() {
        miniPlayBack.updateTrackInfo()
    }
    
    private func updatePlayPauseButton(_ button: UIButton) {
        let playerStatus = playback.player.timeControlStatus
        var imageName = IconSystem.miniPlay.systemName()
        
        switch playerStatus {
        case .paused:
            imageName = IconSystem.miniPlay.systemName()
            print("paused")
        case .waitingToPlayAtSpecifiedRate:
            imageName = IconSystem.miniPlay.systemName()
            print("waiting")
        case .playing:
            if miniPlayBack.isHiddenCustomView {
                UIView.animate(withDuration: 0.5, animations: {
                    MainTabBarVC.tabbarHeight = MainTabBarVC.maxHeight
                    self.miniPlayBack.showCustomView()
                })
            }
            updateTrackInfo()
            imageName = IconSystem.miniPause.systemName()
            print("playing")
        @unknown default:
            imageName = IconSystem.miniPlay.systemName()
            print("unknown")
        }
        
        let image = UIImage(systemName: imageName)
        button.setImage(image, for: .normal)
    }
}

// MARK: MiniPlaybackDelegate
extension MainTabBarVC: MiniPlaybackDelegate {
    func onCustomViewTapped() {
        let vc = TrackViewVC()
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    func onPlayPauseButtonTapped() {
        playback.togglePlayPauseState()
    }
}
