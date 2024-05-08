//
//  AudioTypeResponseDTO+Mapping.swift
//  Rikkeify
//
//  Created by QuocLA on 08/05/2024.
//

import Foundation

struct AudioTypeResponseDTO: Decodable {
    let status: Bool
    let soundcloudTrack: AudioTrackDTO
}

extension AudioTypeResponseDTO {
    struct AudioTrackDTO: Decodable {
        let searchTerm: String
        let id: Int
        let permalink: String
        let title: String
        let audio: [AudioDTO]
    }
}

extension AudioTypeResponseDTO.AudioTrackDTO {
    struct AudioDTO: Decodable {
        let quality: String
        let url: String
        let durationMs: Int64
        let durationText: String
        let mimeType: String
        let format: String
    }
}

// MARK: - Mappings to Domain

extension AudioTypeResponseDTO {
    func toDomain() -> AudioType {
        return .init(type: soundcloudTrack.toDomain())
    }
}

extension AudioTypeResponseDTO.AudioTrackDTO {
    func toDomain() -> AudioTrack {
        return .init(audio: audio.map { $0.toDomain() })
    }
}

extension AudioTypeResponseDTO.AudioTrackDTO.AudioDTO {
    func toDomain() -> Audio {
        return .init(quality: quality,
                     url: url,
                     durationMs: durationMs,
                     durationText: durationText,
                     mimeType: mimeType,
                     format: format)
    }
}
