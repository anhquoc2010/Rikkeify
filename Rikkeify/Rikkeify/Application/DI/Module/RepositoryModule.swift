//
//  RepositoryModule.swift
//  Rikkeify
//
//  Created by QuocLA on 08/05/2024.
//

import Foundation
import Swinject

final class RepositoryModule {
    
    func register(container: Container) {
        container.register(TrackRepository.self) { _ in TrackRepositoryImp() }
        container.register(SectionRepository.self) { _ in SectionRepositoryImp() }
        container.register(CategoryRepository.self) { _ in CategoryRepositoryImp() }
        container.register(SearchRepository.self) { _ in SearchRepositoryImp() }
    }
}
