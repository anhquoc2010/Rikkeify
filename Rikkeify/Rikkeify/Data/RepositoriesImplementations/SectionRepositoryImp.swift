//
//  SectionRepositoryImp.swift
//  Rikkeify
//
//  Created by PearUK on 13/5/24.
//

import Foundation
import Swinject

final class SectionRepositoryImp {
    @Inject
    private var remoteDataSource: SectionRemoteDataSource!
}

extension SectionRepositoryImp: SectionRepository {
    func getGenresAndContents(genreId: String, completion: @escaping (Result<[Section], NetworkError>) -> Void) {
        remoteDataSource.getGenresAndContents(genreId: genreId, completion: completion)
    }
    
    func getSectionContents(type: String, id: String, completion: @escaping (Result<SectionContent, NetworkError>) -> Void) {
        remoteDataSource.getSectionContents(type: type, id: id, completion: completion)
    }
    
    func getSections(completion: @escaping (Result<[Section], NetworkError>) -> Void) {
        remoteDataSource.getSections(completion: completion)
    }
}
