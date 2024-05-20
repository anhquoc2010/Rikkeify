//
//  SearchRemoteDataSource.swift
//  Rikkeify
//
//  Created by QuocLA on 20/05/2024.
//

import Foundation

protocol SearchRemoteDataSource {
    func search(query: String, type: String, numberOfTopResults: Int, completion: @escaping (Result<[SearchItem], NetworkError>) -> Void)
}

final class SearchRemoteDataSourceImp {
    @Inject
    private var networkService: Networkable
}

extension SearchRemoteDataSourceImp: SearchRemoteDataSource {
    func search(query: String, type: String, numberOfTopResults: Int, completion: @escaping (Result<[SearchItem], NetworkError>) -> Void) {
        networkService.sendRequest(endpoint: AppEndpoint.search(query: query, type: type, numberOfTopResults: numberOfTopResults)) { (result: Result<SearchResponseDTO, NetworkError>) in
            switch result {
            case .success(let searchResponseDTO):
                var items = searchResponseDTO.topResults.items.map { $0.data.toDomain() }
                let validTypes: Set<ItemType> = [.artist, .album, .playlist, .track]
                items = items.filter { validTypes.map { $0.rawValue }.contains($0.type) }
                completion(.success(items))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
