//
//  SectionRemoteDataSource.swift
//  Rikkeify
//
//  Created by PearUK on 13/5/24.
//

import Foundation

protocol SectionRemoteDataSource {
    func getSections(completion: @escaping (Result<[Section], NetworkError>) -> Void)
}

final class SectionRemoteDataSourceImp {
    @Inject
    private var networkService: Networkable
}

extension SectionRemoteDataSourceImp: SectionRemoteDataSource {
    func getSections(completion: @escaping (Result<[Section], NetworkError>) -> Void) {
        networkService.sendRequest(endpoint: AppEndpoint.getSections) { (result: Result<SectionResponseDTO, NetworkError>) in
            switch result {
            case .success(var sectionResponseDTO):
                sectionResponseDTO.sections.items = sectionResponseDTO.sections.items.map { sectionItem in
                    var sectionItem = sectionItem
                    let validTypes: Set<ItemType> = [.artist, .album, .playlist]
                    sectionItem.contents.items = sectionItem.contents.items.filter { item in
                        validTypes.map { $0.rawValue }.contains(item.type)
                    }
                    return sectionItem
                }
                
                sectionResponseDTO.sections.items.removeAll { sectionItem in
                    sectionItem.contents.items.isEmpty
                }
                
                completion(.success(sectionResponseDTO.sections.items.map { $0.toDomain() }))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    
}
