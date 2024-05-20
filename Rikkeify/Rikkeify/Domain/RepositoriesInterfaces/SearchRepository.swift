//
//  SearchRepository.swift
//  Rikkeify
//
//  Created by QuocLA on 21/05/2024.
//

import Foundation

protocol SearchRepository {
    func search(query: String, type: String, numberOfTopResults: Int, completion: @escaping (Result<[SearchItem], NetworkError>) -> Void)
}
