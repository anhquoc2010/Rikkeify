//
//  SearchRepositoryImp.swift
//  Rikkeify
//
//  Created by QuocLA on 21/05/2024.
//

import Foundation
import Swinject

final class SearchRepositoryImp {
    @Inject
    private var remoteDataSource: SearchRemoteDataSource!
}

extension SearchRepositoryImp: SearchRepository {
    func search(query: String, type: String, numberOfTopResults: Int, completion: @escaping (Result<[SearchItem], NetworkError>) -> Void) {
        remoteDataSource.search(query: query, type: type, numberOfTopResults: numberOfTopResults, completion: completion)
    }
}
