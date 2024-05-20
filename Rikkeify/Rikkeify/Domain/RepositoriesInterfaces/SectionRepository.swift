//
//  SectionRepository.swift
//  Rikkeify
//
//  Created by PearUK on 13/5/24.
//

import Foundation

protocol SectionRepository {
    func getSections(completion: @escaping (Result<[Section], NetworkError>) -> Void)
    func getSectionContents(type: String, id: String, completion: @escaping (Result<SectionContent, NetworkError>) -> Void)
    func getGenresAndContents(genreId: String, completion: @escaping (Result<[Section], NetworkError>) -> Void)
}
