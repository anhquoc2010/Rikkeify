//
//  NetworkModule.swift
//  Rikkeify
//
//  Created by QuocLA on 08/05/2024.
//

import Foundation
import Swinject

final class NetworkModule {
    
    func register(container: Container) {
        container.register(Networkable.self) { _ in NetworkService() }
    }
}
