//
//  DependencyInjection.swift
//  Rikkeify
//
//  Created by QuocLA on 08/05/2024.
//

import Foundation
import Swinject

public class DI {
    
    static let shared = DI()
    
    let container = Container()
    
    private init() {
        LocalModule().register(container: container)
        NetworkModule().register(container: container)
        PlaybackModule().register(container: container)
        DataSourceModule().register(container: container)
        RepositoryModule().register(container: container)
    }
    
    func resolve<T>() -> T {
        guard let resolvedType = container.resolve(T.self) else {
            fatalError("Failed to resolve \(String(describing: T.self))")
        }
        return resolvedType
    }
}


