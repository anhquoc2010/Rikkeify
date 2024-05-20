//
//  SearchActiveVM.swift
//  Rikkeify
//
//  Created by QuocLA on 20/05/2024.
//

import Foundation
import Swinject

class SearchActiveVM {
    @Inject
    var searchRepository: SearchRepository
    
    var searchResults = [SearchItem]()
    
    func search(query: String, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        searchRepository.search(query: query, type: "multi", numberOfTopResults: 20) { [weak self] (result: Result<[SearchItem], NetworkError>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let searchResults):
                self.searchResults = searchResults
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
