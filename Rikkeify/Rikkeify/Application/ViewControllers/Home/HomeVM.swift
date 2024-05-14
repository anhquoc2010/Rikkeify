//
//  HomeVM.swift
//  Rikkeify
//
//  Created by PearUK on 13/5/24.
//

import Foundation

class HomeVM {
    @Inject
    private var sectionRepository: SectionRepository
    var sections = [Section]()
    
    func fetchSections(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        sectionRepository.getSections { [weak self] (result: Result<[Section], NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let sections):
                self.sections = sections
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
