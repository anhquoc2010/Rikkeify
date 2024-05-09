//
//  Inject.swift
//  Rikkeify
//
//  Created by QuocLA on 08/05/2024.
//

import Foundation
import Swinject

@propertyWrapper
public struct Inject<Value> {
    private(set) public var wrappedValue: Value
    
    public init() {
        self.wrappedValue = DI.shared.resolve()
    }
}
