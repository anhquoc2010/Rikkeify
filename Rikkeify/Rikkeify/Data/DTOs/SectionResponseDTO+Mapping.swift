//
//  SectionResponseDTO.swift
//  Rikkeify
//
//  Created by PearUK on 13/5/24.
//

import Foundation

enum ItemType: String {
    case section, artist, album, playlist, track
}

struct SectionResponseDTO: Decodable {
    let status: Bool
    var sections: SectionsDTO
}

extension SectionResponseDTO {
    struct SectionsDTO: Decodable {
        let totalCount: Int
        var items: [SectionDTO]
    }
}

extension SectionResponseDTO.SectionsDTO {
    struct SectionDTO: Decodable {
        let type: String
        let id: String
        let title: String
        var contents: SectionContentsDTO
    }
}

extension SectionResponseDTO.SectionsDTO.SectionDTO {
    struct SectionContentsDTO: Decodable {
        let totalCount: Int
        var items: [SectionContentDTO]
    }
}

extension SectionResponseDTO.SectionsDTO.SectionDTO.SectionContentsDTO {
    struct SectionContentDTO: Decodable {
        let type: String
        let id: String
        let name: String
        let visuals: VisualDTO?
        let cover: [CoverDTO]?
        let images: [[ImageDTO]]?
    }
}

//extension SectionResponseDTO.SectionsDTO.SectionDTO.SectionContentsDTO {
//    struct ImageResponseDTO: Decodable {
//        let items: [ImageDTO]
//    }
//}

struct ImageDTO: Decodable {
    let url: String
    let width: Int?
    let height: Int?
}

// MARK: - Mappings to Domain

extension SectionResponseDTO.SectionsDTO.SectionDTO {
    func toDomain() -> Section {
        return .init(type: type, id: id, title: title, contents: contents.items.map { $0.toDomain() })
    }
}

extension SectionResponseDTO.SectionsDTO.SectionDTO.SectionContentsDTO.SectionContentDTO {
    func toDomain() -> SectionContent {
        return .init(type: type,
                     id: id,
                     name: name,
                     visuals: visuals?.toDomain(),
                     cover: cover?.map { $0.toDomain() },
                     images: images?[0].map { $0.toDomain() }
        )
    }
}

extension ImageDTO {
    func toDomain() -> Image {
        return .init(url: url, width: width, height: height)
    }
}
