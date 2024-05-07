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
    let track: Track
    
    var loopState: LoopState = .none
    
    var isLiked = false
    var isShuffled = false
    var isPlaying = false
    
    init(track: Track) {
        self.track = track
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
