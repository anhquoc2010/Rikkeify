//
//  TrackOptionVM.swift
//  Rikkeify
//
//  Created by QuocLA on 06/05/2024.
//

import Foundation

class TrackOptionVM {
    let track: Track
    
    var optionList = [TrackOption]()
    
    init(track: Track) {
        self.track = track
    }
    
    func fetchOptions() {
        optionList = [
            TrackOption(icon: "heart", name: "Like"),
            TrackOption(icon: "minus.circle", name: "Hide song"),
            TrackOption(icon: "note.text.badge.plus", name: "Add to playlist"),
            TrackOption(icon: "text.badge.plus", name: "Add to queue"),
            TrackOption(icon: "square.and.arrow.up", name: "Share"),
            TrackOption(icon: "dot.radiowaves.left.and.right", name: "Go to radio"),
            TrackOption(icon: "circle.circle", name: "View album"),
            TrackOption(icon: "person.wave.2", name: "View artist"),
            TrackOption(icon: "person.2", name: "Song credits"),
            TrackOption(icon: "moon", name: "Sleep timer"),
        ]
    }
}
