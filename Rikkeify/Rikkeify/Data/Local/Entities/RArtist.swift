//
//  RArtist.swift
//  Rikkeify
//
//  Created by QuocLA on 21/05/2024.
//

import RealmSwift

class RArtist: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String = ""
    @Persisted var imageUrl: String = ""
    
    static func fromDomain(artist: Artist) -> RArtist {
        let rArtist = RArtist()
        rArtist.id = artist.id
        rArtist.name = artist.name
        rArtist.imageUrl = artist.visuals?.avatar.first?.url ?? ""
        return rArtist
    }
    
    func toDomain() -> Artist {
        return Artist(id: id, name: name, visuals: Visual(avatar: [Avatar(url: imageUrl, width: 0, height: 0)]))
    }
}
