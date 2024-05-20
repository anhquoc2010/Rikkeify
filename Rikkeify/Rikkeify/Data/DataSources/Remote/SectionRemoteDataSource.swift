//
//  SectionRemoteDataSource.swift
//  Rikkeify
//
//  Created by PearUK on 13/5/24.
//

import Foundation

protocol SectionRemoteDataSource {
    func getSections(completion: @escaping (Result<[Section], NetworkError>) -> Void)
    func getSectionContents(type: String, id: String, completion: @escaping (Result<SectionContent, NetworkError>) -> Void)
    func getGenresAndContents(genreId: String, completion: @escaping (Result<[Section], NetworkError>) -> Void)
}

final class SectionRemoteDataSourceImp {
    @Inject
    private var networkService: Networkable
}

extension SectionRemoteDataSourceImp: SectionRemoteDataSource {
    func getGenresAndContents(genreId: String, completion: @escaping (Result<[Section], NetworkError>) -> Void) {
        networkService.sendRequest(endpoint: AppEndpoint.getGenreContents(genreId: genreId)) { (result: Result<GenreResponseDTO, NetworkError>) in
            switch result {
            case .success(var genreResponseDTO):
                genreResponseDTO.contents.items = genreResponseDTO.contents.items.map { genreItem in
                    var genreItem = genreItem
                    let validTypes: Set<ItemType> = [.artist, .album, .playlist, .track]
                    genreItem.contents.items = genreItem.contents.items.filter { item in
                        validTypes.map { $0.rawValue }.contains(item.type)
                    }
                    return genreItem
                }
                
                genreResponseDTO.contents.items.removeAll { genreItem in
                    genreItem.contents.items.isEmpty
                }
                
                completion(.success(genreResponseDTO.contents.items.map { $0.toDomain() }))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getSectionContents(type: String, id: String, completion: @escaping (Result<SectionContent, NetworkError>) -> Void) {
        networkService.sendRequest(endpoint: AppEndpoint.getSectionContent(type: type, id: id)) { (result: Result<SectionContentResponseDTO, NetworkError>) in
            switch result {
            case .success(let sectionContentResponseDTO):
                completion(.success(sectionContentResponseDTO.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
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
