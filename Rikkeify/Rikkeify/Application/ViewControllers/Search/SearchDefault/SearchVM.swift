//
//  SearchVM.swift
//  Rikkeify
//
//  Created by QuocLA on 20/05/2024.
//

import Foundation

class SearchVM {
    @Inject
    private var categoryRepository: CategoryRepository
    
    var categories = [Category]()
    
    func fetchCategories(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        categoryRepository.getExplore { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let categories):
                self.categories = categories
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
