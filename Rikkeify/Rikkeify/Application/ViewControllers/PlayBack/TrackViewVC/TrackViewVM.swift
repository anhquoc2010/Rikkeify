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
    
    init(track: Track) {
        self.track = track
    }
    
    var loopState: LoopState = .none
    
    var isLiked = false
    var isShuffled = false
    var isPlaying = false
    
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
