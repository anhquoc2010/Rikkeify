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
}
