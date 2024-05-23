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
    @Persisted var artists = List<RArtist>()
    @Persisted var album: RAlbum?
    @Persisted var lyrics = List<RLyric>()
    @Persisted var audio: RAudio?
    @Persisted var isFavourited: Bool = false
    
    static func fromDomain(track: Track) -> RTrack {
        let rTrack = RTrack()
        rTrack.id = track.id
        rTrack.name = track.name
        rTrack.durationMs = track.durationMs
        rTrack.durationText = track.durationText
        rTrack.artists.append(objectsIn: track.artists.map { RArtist.fromDomain(artist: $0) })
        rTrack.album = track.album != nil ? RAlbum.fromDomain(album: track.album!) : nil
        rTrack.lyrics.append(objectsIn: track.lyrics.map { RLyric.fromDomain(lyric: $0) })
        rTrack.audio = track.audio.first != nil ? RAudio.fromDomain(audio: track.audio.first!) : nil
        return rTrack
    }
    
    func toDomain() -> Track {
        let track = Track(id: id,
                          name: name,
                          shareUrl: "",
                          durationMs: durationMs,
                          durationText: durationText,
                          trackNumber: nil,
                          playCount: 0,
                          artists: artists.map { $0.toDomain() },
                          album: album?.toDomain(),
                          lyrics: lyrics.map { $0.toDomain() },
                          audio: audio == nil ? [] : [audio!.toDomain()])
        return track
    }
}
