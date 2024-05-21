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
}
