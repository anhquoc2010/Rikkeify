//
//  CategoryResponseDTO+Mapping.swift
//  Rikkeify
//
//  Created by QuocLA on 20/05/2024.
//

import Foundation

// MARK: - Welcome
struct CategoryResponseDTO: Decodable {
    let data: WelcomeDataDTO
}

// MARK: - WelcomeData
struct WelcomeDataDTO: Decodable {
    let browseStart: BrowseStartDTO
}

// MARK: - BrowseStart
struct BrowseStartDTO: Decodable {
    let sections: SectionsDTO
}

// MARK: - Sections
struct SectionsDTO: Decodable {
    let items: [SectionsItemDTO]
}

// MARK: - SectionsItem
struct SectionsItemDTO: Decodable {
    let data: ItemDataDTO
    let sectionItems: SectionItemsDTO
}

// MARK: - ItemData
struct ItemDataDTO: Decodable {
    let title: TitleDTO
}

// MARK: - Title
struct TitleDTO: Decodable {
    let transformedLabel: String
}

// MARK: - SectionItems
struct SectionItemsDTO: Decodable {
    let items: [SectionItemsItemDTO]
}

// MARK: - SectionItemsItem
struct SectionItemsItemDTO: Decodable {
    let uri: String
    let content: ContentDTO
}

// MARK: - Content
struct ContentDTO: Decodable {
    let data: ContentDataDTO
}

// MARK: - ContentData
struct ContentDataDTO: Decodable {
    let data: DataDataDTO?
    let title: TitleDTO?
    let artwork: ArtworkDTO?
    let backgroundColor: BackgroundColorDTO?
}

// MARK: - Artwork
struct ArtworkDTO: Decodable {
    let sources: [SourceDTO]
}

// MARK: - Source
struct SourceDTO: Decodable {
    let url: String
}

// MARK: - BackgroundColor
struct BackgroundColorDTO: Decodable {
    let hex: String
}

// MARK: - DataData
struct DataDataDTO: Decodable {
    let cardRepresentation: CardRepresentationDTO
}

// MARK: - CardRepresentation
struct CardRepresentationDTO: Decodable {
    let title: TitleDTO
    let artwork: ArtworkDTO
    let backgroundColor: BackgroundColorDTO
}

extension SectionItemsItemDTO {
    func toDomain() -> Category {
        let id = uri.components(separatedBy: ":").last
        if let data = content.data.data {
            return .init(id: id ?? "",
                         title: data.cardRepresentation.title.transformedLabel,
                         artwork: data.cardRepresentation.artwork.sources.first?.url ?? "",
                         backgroundColor: data.cardRepresentation.backgroundColor.hex)
        } else {
            return .init(id: id ?? "",
                         title: content.data.title?.transformedLabel ?? "",
                         artwork: content.data.artwork?.sources.first?.url ?? "",
                         backgroundColor: content.data.backgroundColor?.hex ?? "")
        }
    }
}
