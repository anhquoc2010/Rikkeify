//
//  GenreVM.swift
//  Rikkeify
//
//  Created by QuocLA on 21/05/2024.
//

import Foundation

class GenreVM {
    @Inject
    private var sectionRepository: SectionRepository
    var genres = [Section]()
    var genreId: String
    var title: String = ""
    
    init(genreId: String) {
        self.genreId = genreId
    }
    
    func fetchGenres(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        sectionRepository.getGenresAndContents(genreId: genreId) { [weak self] (result: Result<[Section], NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let genres):
                self.genres = genres
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
