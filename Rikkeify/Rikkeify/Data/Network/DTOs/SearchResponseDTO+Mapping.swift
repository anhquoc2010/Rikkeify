//
//  SearchResponseDTO+Mapping.swift
//  Rikkeify
//
//  Created by QuocLA on 20/05/2024.
//

import Foundation

// MARK: - SearchResult
struct SearchResponseDTO: Decodable {
    let topResults: TopResultsDTO
}

// MARK: - TopResults
struct TopResultsDTO: Decodable {
    let items: [TopResultsItemDTO]
}

// MARK: - TopResultsItem
struct TopResultsItemDTO: Decodable {
    let data: DataClassDTO
}

// MARK: - DataClass
struct DataClassDTO: Decodable {
    let uri: String
    let id, name: String?
    let albumOfTrack: AlbumOfTrackDTO?
    let artists: ArtistsDTO?
    let profile: OwnerDTO?
    let visuals: VisualsDTO?
    let images: ImagesDTO?
    let coverArt: CoverArtDTO?
    let displayName: String?
    let image: ImageSearchDTO?
}

// MARK: - AlbumOfTrack
struct AlbumOfTrackDTO: Decodable {
    let name: String
    let coverArt: CoverArtDTO
    let id: String
}

// MARK: - CoverArt
struct CoverArtDTO: Decodable {
    let sources: [SourceDTO]
}

// MARK: - Artists
struct ArtistsDTO: Decodable {
    let items: [ArtistsItemDTO]
}

// MARK: - ArtistsItem
struct ArtistsItemDTO: Decodable {
    let uri: String
    let profile: OwnerDTO
}

// MARK: - Owner
struct OwnerDTO: Decodable {
    let name: String
}

// MARK: - Image
struct ImageSearchDTO: Decodable {
    let smallImageURL, largeImageURL: String?

    enum CodingKeys: String, CodingKey {
        case smallImageURL = "smallImageUrl"
        case largeImageURL = "largeImageUrl"
    }
}

// MARK: - Images
struct ImagesDTO: Decodable {
    let items: [CoverArtDTO]
}

// MARK: - Visuals
struct VisualsDTO: Decodable {
    let avatarImage: CoverArtDTO
}

extension DataClassDTO {
    func toDomain() -> SearchItem {
        let imageUrl = image?.largeImageURL
        ?? images?.items.first?.sources.first?.url
        ?? coverArt?.sources.first?.url
        ?? visuals?.avatarImage.sources.first?.url
        ?? albumOfTrack?.coverArt.sources.first?.url
        ?? ""

        let title = name
        ?? albumOfTrack?.name
        ?? profile?.name
        ?? displayName
        ?? artists?.items.first?.profile.name
        ?? ""

        let typeComponents = uri.components(separatedBy: ":")
        let type = typeComponents.count >= 2 ? typeComponents[1] : ""
        let id = typeComponents.last ?? ""

        return SearchItem(image: imageUrl, title: title, type: type, id: id)
    }
}
