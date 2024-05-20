//
//  CategoryRepositoryImp.swift
//  Rikkeify
//
//  Created by QuocLA on 20/05/2024.
//

import Foundation
import Swinject

final class CategoryRepositoryImp {
    @Inject
    private var remoteDataSource: CategoryRemoteDataSource!
}

extension CategoryRepositoryImp: CategoryRepository {
    func getExplore(completion: @escaping (Result<[Category], NetworkError>) -> Void) {
        remoteDataSource.getExplore(completion: completion)
    }
}
