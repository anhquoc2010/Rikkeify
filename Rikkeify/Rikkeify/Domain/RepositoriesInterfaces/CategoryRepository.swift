//
//  CategoryRepository.swift
//  Rikkeify
//
//  Created by QuocLA on 20/05/2024.
//

import Foundation

protocol CategoryRepository {
    func getExplore(completion: @escaping (Result<[Category], NetworkError>) -> Void)
}
