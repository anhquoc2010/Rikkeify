//
//  LyricsResponseDTO+Mapping.swift
//  Rikkeify
//
//  Created by QuocLA on 08/05/2024.
//

import Foundation

struct LyricsResponseDTO: Decodable {
    let startMs: Int
    let durMs: Int
    let text: String
}

// MARK: - Mappings to Domain

extension LyricsResponseDTO {
    func toDomain() -> Lyric {
        return .init(startMs: startMs, durMs: durMs, text: text)
    }
}
