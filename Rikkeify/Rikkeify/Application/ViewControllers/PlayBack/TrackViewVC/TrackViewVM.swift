//
//  TrackViewVM.swift
//  Rikkeify
//
//  Created by PearUK on 7/5/24.
//

import AVFoundation

enum LoopState {
    case none, loop, loopOne
}

class TrackViewVM {
    @Inject
    private var trackRepository: TrackRepository
    private let trackId: String
    
    var track: Track!
    
    private var audioTrack: Audio?
    private var audioTracks = [Audio]()
    
    var currentAudioTrackIndex = 0
    
    var currentAudioTrack: Audio? {
        if let audioTrack = audioTrack, audioTracks.isEmpty {
            return audioTrack
        }
        else if let _ = self.playerQueue, !audioTracks.isEmpty {
            return audioTracks[currentAudioTrackIndex]
        }
        return nil
    }
    
    var player: AVPlayer?
    var playerQueue: AVQueuePlayer?
    
    var loopState: LoopState = .none
    
    var isLiked = false
    var isShuffled = false
    
    init(trackId: String) {
        self.trackId = trackId
    }
    
    func fetchTrackMetadata(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        trackRepository.getTrackMetadata(trackId: trackId) { [weak self] (result: Result<Track, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let track):
                self.track = track
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func startPlayback(audioTrack: Audio) {
        guard let url = URL(string: audioTrack.url) else { return }
        self.audioTrack = audioTrack
        self.audioTracks = []
        player = AVPlayer(url: url)
        player?.automaticallyWaitsToMinimizeStalling = true
        player?.actionAtItemEnd = .pause
        player?.volume = 1.0
        player?.play()
    }
    
    func startPlayback(audioTracks: [Audio]) {
        self.audioTracks = audioTracks
        self.audioTrack = nil
        
        self.playerQueue = AVQueuePlayer(items: audioTracks.compactMap {
            guard let url = URL(string: $0.url) else {
                return nil
            }
            return AVPlayerItem(url: url)
        })
        self.playerQueue?.volume = 1.0
        self.playerQueue?.play()
    }
    
    func didSlideSlider(toTime time: Double) {
        player?.seek(to: .init(seconds: time / 1000, preferredTimescale: 1))
    }
    
    func togglePlayPauseState() {
        if let player = player {
            player.timeControlStatus == .playing ? player.pause() : player.play()
        } else if let player = playerQueue {
            player.timeControlStatus == .playing ? player.pause() : player.play()
        }
    }
    
    func toggleLoopState() {
        switch loopState {
        case .none:
            loopState = .loop
        case .loop:
            loopState = .loopOne
        case .loopOne:
            loopState = .none
        }
    }
    
    func toggleShuffleState() {
        isShuffled.toggle()
    }
    
    func toggleLikeState() {
        isLiked.toggle()
    }
}
