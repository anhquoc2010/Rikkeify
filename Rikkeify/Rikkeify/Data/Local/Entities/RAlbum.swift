//
//  RAlbum.swift
//  Rikkeify
//
//  Created by QuocLA on 21/05/2024.
//

import RealmSwift

class RAlbum: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var name: String = ""
    @Persisted var shareUrl: String = ""
    @Persisted var imageUrl: String = ""
    
    static func fromDomain(album: Album) -> RAlbum {
        let rAlbum = RAlbum()
        rAlbum.id = album.id
        rAlbum.name = album.name
        rAlbum.shareUrl = album.shareUrl
        rAlbum.imageUrl = album.cover.first?.url ?? ""
        return rAlbum
    }
    
    func toDomain() -> Album {
        return Album(id: id, name: name, shareUrl: shareUrl, cover: [Cover(url: imageUrl, width: 0, height: 0)])
    }
}
