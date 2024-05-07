//
//  LyricViewVM.swift
//  Rikkeify
//
//  Created by QuocLA on 07/05/2024.
//

import Foundation

class LyricViewVM {
    let track: Track
    
    var isPlaying = false
    
    init(track: Track) {
        self.track = track
    }
    
    func togglePlayPauseState() {
        isPlaying.toggle()
    }
}
