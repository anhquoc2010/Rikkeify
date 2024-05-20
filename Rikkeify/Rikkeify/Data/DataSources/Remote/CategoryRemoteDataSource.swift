//
//  CategoryRemoteDataSource.swift
//  Rikkeify
//
//  Created by QuocLA on 20/05/2024.
//

import Foundation

protocol CategoryRemoteDataSource {
    func getExplore(completion: @escaping (Result<[Category], NetworkError>) -> Void)
}

final class CategoryRemoteDataSourceImp {
    @Inject
    private var networkService: Networkable
}

extension CategoryRemoteDataSourceImp: CategoryRemoteDataSource {
    func getExplore(completion: @escaping (Result<[Category], NetworkError>) -> Void) {
        networkService.sendRequest(endpoint: AppEndpoint.getExplore) { (result: Result<CategoryResponseDTO, NetworkError>) in
            switch result {
            case .success(let categoryResponseDTO):
                completion(.success(categoryResponseDTO.data.browseStart.sections.items.flatMap {
                    $0.sectionItems.items.map { $0.toDomain() }
                }))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
