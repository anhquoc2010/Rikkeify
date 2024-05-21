//
//  RAudio.swift
//  Rikkeify
//
//  Created by QuocLA on 21/05/2024.
//

import RealmSwift

class RAudio: Object {
    @Persisted var quality: String = ""
    @Persisted var url: String = ""
    @Persisted var durationMs: Int64 = 0
    @Persisted var durationText: String = ""
    @Persisted var mimeType: String = ""
    @Persisted var format: String = ""
}
