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
    func getSections(completion: @escaping (Result<[Section], NetworkError>) -> Void) {
        remoteDataSource.getSections(completion: completion)
    }
    
}
