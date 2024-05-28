//
//  MiniPlaybackView.swift
//  Rikkeify
//
//  Created by PearUK on 15/5/24.
//

import UIKit
import AVFoundation

protocol MiniPlaybackDelegate: AnyObject {
    func onPlayPauseButtonTapped()
    func onCustomViewTapped()
}

class MiniPlaybackView: UIView {
    
    let player = PlaybackPresenter.shared
    
    var view: UIView!
    var isHiddenCustomView = false
    
    weak var delegate: MiniPlaybackDelegate?
    
    @IBOutlet weak var trackProgressView: UIProgressView!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var musicNameLabel: UILabel!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var miniPlaybackView: UIView!
    @IBOutlet weak var tabBar: UITabBar!
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = tabBar.sizeThatFits(size)
        sizeThatFits.height = CGFloat(MainTabBarVC.tabbarHeight)
        return sizeThatFits
    }
    
    // MARK: Lifecycle
    
    convenience init(copyWith tabBar: UITabBar) {
        self.init(frame: tabBar.frame)
        self.tabBar.tintColor = tabBar.tintColor
        self.tabBar.isTranslucent = tabBar.isTranslucent
        self.tabBar.standardAppearance = tabBar.standardAppearance
        self.tabBar.items = tabBar.items
        self.tabBar.selectedItem = tabBar.selectedItem
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetup()
    }
    
    
    @IBAction func onPlayPauseButtonTapped(_ sender: UIButton) {
        
        delegate?.onPlayPauseButtonTapped()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        view.frame = bounds
        
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        let guide = self.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            view.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: guide.trailingAnchor)
        ])
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "\(type(of: self))", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    func showCustomView() {
        isHiddenCustomView = false
        miniPlaybackView.alpha = 1
        playPauseButton.isEnabled = true
        miniPlaybackView.isUserInteractionEnabled = true
        view.backgroundColor = .systemBackground
    }
    
    func hideCustomView() {
        isHiddenCustomView = true
        miniPlaybackView.alpha = 1
        view.backgroundColor = .systemBackground
        thumbImageView.image = .icApp
        musicNameLabel.text = ""
        artistLabel.text = ""
        playPauseButton.isEnabled = false
        miniPlaybackView.isUserInteractionEnabled = false
        let newY = frame.origin.y - CGFloat(MainTabBarVC.maxHeight) + CGFloat(MainTabBarVC.minHeight)
        frame = CGRect(x: 0, y: newY, width: frame.width, height: CGFloat(MainTabBarVC.maxHeight))
    }
    
    func updateTrackInfo() {
        thumbImageView.setNetworkImage(urlString: player.currentTrack.album?.cover.first?.url ?? "")
        musicNameLabel.text = player.currentTrack.name
        artistLabel.text = player.currentTrack.artists.first?.name
    }
    
    @objc func onTapCustomView(_ sender: UITapGestureRecognizer? = nil) {
        delegate?.onCustomViewTapped()
    }
}
