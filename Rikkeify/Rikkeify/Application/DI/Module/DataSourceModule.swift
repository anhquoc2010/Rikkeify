//
//  DataSourceModule.swift
//  Rikkeify
//
//  Created by QuocLA on 08/05/2024.
//

import Foundation
import Swinject

final class DataSourceModule {
    
    func register(container: Container) {
        container.register(TrackRemoteDataSource.self) { _ in TrackRemoteDataSourceImp() }
        container.register(SectionRemoteDataSource.self) { _ in SectionRemoteDataSourceImp() }
    }
}
