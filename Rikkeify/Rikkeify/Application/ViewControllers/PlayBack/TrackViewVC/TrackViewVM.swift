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
    private var trackId: String
    
    var tracks = [Track]()
    var recommendTracks = [RecommendTrack]()
    
    var currentTrackIndex = 0
    
    var isFirstLoad = true
    
    var isFirstTrack: Bool {
        currentTrackIndex - 1 < 0
    }
    
    var isLastTrack: Bool {
        currentTrackIndex + 1 > playerItems.count
    }
    
    var player: AVPlayer?
    var playerItems = [AVPlayerItem]()
    
    var loopState: LoopState = .none
    
    var isLiked = false
    var isShuffled = false
    
    init(trackId: String) {
        self.trackId = trackId
    }
    
    func fetchTrackMetadata(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        trackRepository.getTrackMetadata(trackId: currentTrackIndex == 0 ? trackId : tracks[currentTrackIndex].id, getAudio: true) { [weak self] (result: Result<Track, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let track):
                self.tracks.append(track)
                guard let url = URL(string: track.audio[0].url) else { return }
                self.playerItems.append(AVPlayerItem(url: url))
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchRecommendTracks(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        trackRepository.getRecommendTracks(seedTrackId: currentTrackIndex == 0 ? trackId : tracks[currentTrackIndex].id) { [weak self] (result: Result<[RecommendTrack], NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let recommendTracks):
                self.recommendTracks = recommendTracks
                let newTracks = recommendTracks.map { $0.audio[0] }
                self.addTracksToQueue(tracks: newTracks)
                checkplayerItems()
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
        
        func checkplayerItems() {
            guard let _ = self.player else {
                print("Player is not initialized.")
                return
            }
            print("Items in player queue:")
            for index in 0..<playerItems.count {
                let item = playerItems[index]
                print("Item \(index + 1): \(item.asset)")
            }
        }
    }
    
    func preFetchNextTrackMetadata(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        trackRepository.getTrackMetadata(trackId: recommendTracks[currentTrackIndex <= recommendTracks.count ? currentTrackIndex : currentTrackIndex - (5 * (tracks.count / 5))].id, getAudio: false) { [weak self] (result: Result<Track, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(var track):
                track.audio = recommendTracks[0].audio
                self.tracks.append(track)
                print(tracks)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func startPlayback() {
        guard let url = URL(string: tracks[currentTrackIndex].audio[0].url) else { return }
        self.player = AVPlayer(url: url)
        self.player?.automaticallyWaitsToMinimizeStalling = true
        self.player?.volume = 1.0
        self.player?.play()
    }
    
    private func addTracksToQueue(tracks: [Audio]) {        
        tracks.forEach { audio in
            guard let url = URL(string: audio.url) else { return }
            self.playerItems.append(AVPlayerItem(url: url))
        }
    }
    
    func didSlideSlider(toTime time: Double) {
        self.player?.seek(to: .init(seconds: time / 1000, preferredTimescale: 1))
    }
    
    func didTapForward(completion: @escaping () -> ()) {
        if let _ = player {
            if isLastTrack {
                currentTrackIndex = 0
            } else {
                currentTrackIndex += 1;
            }
            completion()
            playTrack()
        }
    }
    
    func didTapBackward(completion: @escaping () -> ()) {
        if let _ = player {
            if isFirstTrack {
                currentTrackIndex = 0
            } else {
                currentTrackIndex -= 1
            }
            completion()
            playTrack()
        }
    }
    
    func playTrack() {
        if let player = player, playerItems.count > 0 {
            player.replaceCurrentItem(with: playerItems[currentTrackIndex])
            player.play()
        }
    }
    
    func togglePlayPauseState() {
        if let player = player {
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
