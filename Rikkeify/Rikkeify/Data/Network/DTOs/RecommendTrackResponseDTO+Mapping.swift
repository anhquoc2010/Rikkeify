//
//  RecommendTracksResponseDTO+Mapping.swift
//  Rikkeify
//
//  Created by PearUK on 10/5/24.
//

import Foundation

struct RecommendTracksResponseDTO: Decodable {
    var tracks: [RecommendTrackDTO]
}

extension RecommendTracksResponseDTO {
    struct RecommendTrackDTO: Decodable {
        let id: String
        let name: String
        var audio: AudioTypeResponseDTO?
    }
}

// MARK: - Mappings to Domain

extension RecommendTracksResponseDTO.RecommendTrackDTO {
    func toDomain() -> RecommendTrack {
        return .init(id: id, name: name, audio: audio?.soundcloudTrack.audio.map { $0.toDomain() } ?? [] )
    }
}
