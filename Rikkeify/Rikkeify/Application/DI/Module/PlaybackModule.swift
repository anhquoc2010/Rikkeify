//
//  PlaybackModule.swift
//  Rikkeify
//
//  Created by PearUK on 16/5/24.
//

import Foundation
import Swinject

final class PlaybackModule {
    
    func register(container: Container) {
        container.register(PlaybackPresenter.self) { _ in PlaybackPresenter.shared }
    }
}
