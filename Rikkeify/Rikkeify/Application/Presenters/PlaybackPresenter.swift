//
//  PlaybackPresenter.swift
//  Rikkeify
//
//  Created by PearUK on 15/5/24.
//

import UIKit
import AVFoundation
import Combine
import Kingfisher

final class PlaybackPresenter {
    static let shared = PlaybackPresenter()
    
    private init() {
        activateSession()
        canellable = NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)
            .sink { [weak self] _ in
                guard let me = self else { return }
                
                me.deactivateSession()
            }
    }
    
    deinit {
        canellable?.cancel()
    }
    
    @Inject
    private var trackRepository: TrackRepository
    
    var tracks = [Track]()
    var currentTrackIndex = 0
    var player = AVPlayer()
    var playerItems = [AVPlayerItem?]()
    private var session = AVAudioSession.sharedInstance()
    private var canellable: AnyCancellable?
    var playedIndex = Set<Int>()
    var currentSectionContentId: String = ""
    
    var loopState: LoopState = .none
    var isShuffled = false
    
    var loopedOnce = false
    
    var currentTrack: Track {
        tracks[currentTrackIndex]
    }
    
    var isPlaying: Bool {
        player.timeControlStatus == .playing
    }
    
    var isFirstTrack: Bool {
        currentTrackIndex - 1 < 0
    }
    
    var isLastTrack: Bool {
        currentTrackIndex + 1 >= tracks.count
    }
    
    private func activateSession() {
        do {
            try session.setCategory(
                .playback,
                mode: .default,
                options: []
            )
        } catch _ {}
        
        do {
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch _ {}
        
        do {
            try session.overrideOutputAudioPort(.speaker)
        } catch _ {}
    }
    
    func deactivateSession() {
        do {
            try session.setActive(false, options: .notifyOthersOnDeactivation)
        } catch let error as NSError {
            print("Failed to deactivate audio session: \(error.localizedDescription)")
        }
    }
    
    func fetchTrackMetadata(index: Int, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        trackRepository.getTrackMetadata(trackId: tracks[index].id, getAudio: true) { [weak self] (result: Result<Track, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let track):
                self.tracks[index] = track
                guard let url = URL(string: track.audio.first?.url ?? "") else { return }
                self.playerItems[index] = AVPlayerItem(url: url)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func playTrack(index: Int) {
        if playerItems.count > 0 {
            activateSession()
            player.replaceCurrentItem(with: playerItems[index])
            player.seek(to: .init(seconds: 0, preferredTimescale: 1))
            player.automaticallyWaitsToMinimizeStalling = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.player.play()
            }
            playedIndex.insert(index)
        }
    }
    
    func playNextTrack(didTapForward: Bool = false, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        if !didTapForward {
            handleLoop { [weak self] result in
                guard let _ = self else { return }
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            if isShuffled {
                handleShuffle { [weak self] result in
                    guard let _ = self else { return }
                    switch result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            } else {
                handleNextTrack() { [weak self] result in
                    guard let _ = self else { return }
                    switch result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    private func handleNextTrack(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        if self.isLastTrack {
            self.currentTrackIndex = 0
            completion(.success(()))
        } else {
            self.currentTrackIndex += 1
            if self.playerItems[currentTrackIndex] != nil {
                completion(.success(()))
            } else {
                self.fetchTrackMetadata(index: currentTrackIndex) { [weak self] result in
                    guard let _ = self else { return }
                    switch result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    private func handleShuffle(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        
        repeat {
            let randomInt = Int(arc4random_uniform(UInt32(tracks.count)))
            self.currentTrackIndex = randomInt
        } while playedIndex.contains(self.currentTrackIndex) && playedIndex.count < tracks.count
        
        dispatchGroup.leave()
        
        dispatchGroup.notify(queue: .main) {
            if self.playerItems[self.currentTrackIndex] != nil {
                completion(.success(()))
            } else {
                self.fetchTrackMetadata(index: self.currentTrackIndex) { [weak self] result in
                    guard let _ = self else { return }
                    switch result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    private func handleLoop(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        switch loopState {
        case .loop:
            loopedOnce = false
            completion(.success(()))
        case .loopOne:
            if !loopedOnce {
                completion(.success(()))
                loopedOnce = true
            } else {
                loopedOnce = false
                handleNextTrack { [weak self] result in
                    guard let _ = self else { return }
                    switch result {
                    case .success:
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }
        case .none:
            loopedOnce = false
            handleNextTrack { [weak self] result in
                guard let _ = self else { return }
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func onPreviousTrack(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        if isFirstTrack {
            currentTrackIndex = 0
        } else {
            currentTrackIndex -= 1
        }
        
        if self.playerItems[currentTrackIndex] != nil {
            completion(.success(()))
        } else {
            self.fetchTrackMetadata(index: currentTrackIndex) { [weak self] result in
                guard let _ = self else { return }
                switch result {
                case .success:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    func didSlideSlider(toTime time: Double) {
        self.player.seek(to: .init(seconds: time / 1000, preferredTimescale: 1))
    }
    
    func togglePlayPauseState() {
        isPlaying ? player.pause() : player.play()
    }
    
    func toggleLoopState() {
        switch loopState {
        case .none:
            loopState = .loop
        case .loop:
            loopState = .loopOne
            loopedOnce = false
        case .loopOne:
            loopState = .none
        }
    }
    
    func toggleShuffleState() {
        isShuffled.toggle()
    }
}
