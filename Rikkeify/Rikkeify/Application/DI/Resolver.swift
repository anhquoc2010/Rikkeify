//
//  Resolver.swift
//  Rikkeify
//
//  Created by QuocLA on 08/05/2024.
//

import Swinject

extension Resolver {
    public func resolve<T>() -> T {
        guard let resolvedType = resolve(T.self) else {
            fatalError("Failed to resolve \(String(describing: T.self))")
        }
        
        return resolvedType
    }
}
