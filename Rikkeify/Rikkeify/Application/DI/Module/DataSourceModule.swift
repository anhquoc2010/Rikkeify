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
        container.register(TrackLocalDataSource.self) { _ in TrackLocalDataSourceImp() }
        container.register(TrackRemoteDataSource.self) { _ in TrackRemoteDataSourceImp() }
        container.register(SectionRemoteDataSource.self) { _ in SectionRemoteDataSourceImp() }
        container.register(CategoryRemoteDataSource.self) { _ in CategoryRemoteDataSourceImp() }
        container.register(SearchRemoteDataSource.self) { _ in SearchRemoteDataSourceImp() }
    }
}
