//
//  TrackViewVM.swift
//  Rikkeify
//
//  Created by PearUK on 7/5/24.
//

import Foundation

enum LoopState {
    case none, loop, loopOne
}

class TrackViewVM {
    @Inject
    private var trackRepository: TrackRepository
    private let trackId: String
    
    var track: Track!
    
    var loopState: LoopState = .none
    
    var isLiked = false
    var isShuffled = false
    var isPlaying = false
    
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
    
    func togglePlayPauseState() {
        isPlaying.toggle()
    }
    
    func toggleShuffleState() {
        isShuffled.toggle()
    }
    
    func toggleLikeState() {
        isLiked.toggle()
    }
}
