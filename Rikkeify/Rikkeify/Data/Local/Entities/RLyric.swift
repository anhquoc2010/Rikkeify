//
//  RLyric.swift
//  Rikkeify
//
//  Created by QuocLA on 21/05/2024.
//

import RealmSwift

class RLyric: Object {
    @Persisted var startMs: Int = 0
    @Persisted var durMs: Int = 0
    @Persisted var text: String = ""
    
    static func fromDomain(lyric: Lyric) -> RLyric {
        let rLyric = RLyric()
        rLyric.startMs = lyric.startMs
        rLyric.durMs = lyric.durMs
        rLyric.text = lyric.text
        return rLyric
    }
    
    func toDomain() -> Lyric {
        return Lyric(startMs: startMs, durMs: durMs, text: text)
    }
}
