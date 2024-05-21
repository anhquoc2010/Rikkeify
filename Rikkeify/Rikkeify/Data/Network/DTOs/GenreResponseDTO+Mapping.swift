//
//  GenreResponseDTO+Mapping.swift
//  Rikkeify
//
//  Created by QuocLA on 21/05/2024.
//

import Foundation

struct GenreResponseDTO: Decodable {
    let status: Bool
    let type: String
    let id: String
    let name: String
    var contents: GenreContentDTO
}

extension GenreResponseDTO {
    struct GenreContentDTO: Decodable {
        let totalCount: Int
        var items: [GenreItemDTO]
    }
}

extension GenreResponseDTO.GenreContentDTO {
    struct GenreItemDTO: Decodable {
        let type: String
        let id: String
        let name: String?
        var contents: GenreItemItemDTO
    }
}

extension GenreResponseDTO.GenreContentDTO.GenreItemDTO {
    struct GenreItemItemDTO: Decodable {
        let totalCount: Int
        var items: [SectionContentResponseDTO]
    }
}

extension GenreResponseDTO.GenreContentDTO.GenreItemDTO {
    func toDomain() -> Section {
        return .init(type: type,
                     id: id,
                     title: name ?? "",
                     contents: contents.items.map { $0.toDomain() })
    }
}
