//
//  IconSystem.swift
//  Rikkeify
//
//  Created by PearUK on 16/5/24.
//

import Foundation

enum IconSystem {
    case sliderThumb, loop, loopOne, play, pause, like, liked, miniPlay, miniPause, startDownload, downloaded
    
    func systemName() -> String {
        switch self {
        case .sliderThumb:
            return "circle.fill"
        case .loop:
            return "repeat"
        case .loopOne:
            return "repeat.1"
        case .play:
            return "play.circle.fill"
        case .pause:
            return "pause.circle.fill"
        case .like:
            return "heart"
        case .liked:
            return "heart.fill"
        case .miniPlay:
            return "play.fill"
        case .miniPause:
            return "pause.fill"
        case .startDownload:
            return "arrow.down.circle"
        case .downloaded:
            return "arrow.down.circle.fill"
        }
    }
}
