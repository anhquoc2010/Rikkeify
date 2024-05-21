//
//  RTrack.swift
//  Rikkeify
//
//  Created by QuocLA on 21/05/2024.
//

import RealmSwift

class RTrack: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String = ""
    @Persisted var durationMs: Int64 = 0
    @Persisted var durationText: String = ""
    let artists = List<RArtist>()
    @Persisted var album: RAlbum?
    let lyrics = List<RLyric>()
    let audio = List<RAudio>()
}
