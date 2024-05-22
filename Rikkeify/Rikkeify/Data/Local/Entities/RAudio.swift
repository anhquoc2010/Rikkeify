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
    @Persisted var fileUrl: String = ""
    
    static func fromDomain(audio: Audio) -> RAudio {
        let rAudio = RAudio()
        rAudio.quality = audio.quality
        rAudio.url = audio.url
        rAudio.durationMs = audio.durationMs
        rAudio.durationText = audio.durationText
        rAudio.mimeType = audio.mimeType
        rAudio.format = audio.format
        rAudio.fileUrl = audio.fileUrl ?? ""
        return rAudio
    }
    
    func toDomain() -> Audio {
        return Audio(quality: quality,
                     url: url,
                     durationMs: durationMs,
                     durationText: durationText,
                     mimeType: mimeType,
                     format: format,
                     fileUrl: fileUrl)
    }
}
