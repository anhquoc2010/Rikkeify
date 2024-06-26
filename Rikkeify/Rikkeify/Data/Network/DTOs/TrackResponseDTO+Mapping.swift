//
//  TrackResponseDTO+Mapping.swift
//  Rikkeify
//
//  Created by QuocLA on 08/05/2024.
//

import Foundation

struct TrackResponseDTO: Decodable {
    let status: Bool?
    let type: String?
    let id: String
    let name: String
    let shareUrl: String
    let durationMs: Int64
    let durationText: String
    let trackNumber: Int?
    let playCount: Int64?
    let artists: [ArtistDTO]?
    let album: AlbumDTO?
    var lyrics: [LyricsResponseDTO]?
    var audio: AudioTypeResponseDTO?
//    var recommendTracks: [RecommendTrackResponseDTO]?
    
    enum CodingKeys: String, CodingKey {
        case status
        case type
        case id
        case name
        case shareUrl
        case durationMs
        case durationText
        case trackNumber
        case playCount
        case artists
        case album
        case lyrics
        case audio
//        case recommendTracks = "tracks"
    }
}

struct ArtistDTO: Decodable {
    let type: String
    let id: String
    let name: String
    let shareUrl: String
    let visuals: VisualDTO?
}

struct AlbumDTO: Decodable {
    let type: String
    let id: String
    let name: String?
    let shareUrl: String
    let cover: [CoverDTO]
    let trackCount: Int?
}

struct VisualDTO: Decodable {
    let avatar: [AvatarDTO]
}

struct AvatarDTO: Decodable {
    let width: Int
    let height: Int
    let url: String
}

struct CoverDTO: Decodable {
    let url: String
    let width: Int?
    let height: Int?
}

// MARK: - Mappings to Domain

extension TrackResponseDTO {
    func toDomain() -> Track {
        return .init(id: id,
                     name: name,
                     shareUrl: shareUrl,
                     durationMs: durationMs,
                     durationText: durationText,
                     trackNumber: trackNumber,
                     playCount: playCount,
                     artists: artists?.map { $0.toDomain() } ?? [],
                     album: album?.toDomain(),
                     lyrics: lyrics?.map { $0.toDomain() } ?? [],
                     audio: audio?.soundcloudTrack.audio.map { $0.toDomain() } ?? []
//                     recommendTracks: recommendTracks?.map { $0.toDomain() } ?? []
        )
    }
}

extension ArtistDTO {
    func toDomain() -> Artist {
        return .init(id: id, name: name, visuals: visuals?.toDomain())
    }
}

extension VisualDTO {
    func toDomain() -> Visual {
        return .init(avatar: avatar.map { $0.toDomain() })
    }
}

extension AvatarDTO {
    func toDomain() -> Avatar {
        return .init(url: url, width: width, height: height)
    }
}

extension AlbumDTO {
    func toDomain() -> Album {
        return .init(id: id, name: name ?? "", shareUrl: shareUrl, cover: cover.map { $0.toDomain() })
    }
}

extension CoverDTO {
    func toDomain() -> Cover {
        return .init(url: url, width: width ?? 0, height: height ?? 0)
    }
}
