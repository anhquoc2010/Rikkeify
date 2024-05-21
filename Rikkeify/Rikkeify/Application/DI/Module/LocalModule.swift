//
//  LocalModule.swift
//  Rikkeify
//
//  Created by QuocLA on 21/05/2024.
//

import Foundation
import Swinject

final class LocalModule {
    
    func register(container: Container) {
        container.register(RealmManager.self) { _ in RealmManager.shared }
    }
}
