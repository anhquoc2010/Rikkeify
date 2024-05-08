//
//  ViewModelModule.swift
//  Rikkeify
//
//  Created by QuocLA on 08/05/2024.
//

import Foundation
import Swinject

final class ViewModelModule{
    
    func register(container: Container) {
        container.register(TrackViewVM.self) { _ in TrackViewVM(trackId: "6YndJvp5XpMuzmtWLWI8hp") }
    }
}
