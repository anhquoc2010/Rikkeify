//
//  SectionContent.swift
//  Rikkeify
//
//  Created by PearUK on 13/5/24.
//

import Foundation

struct SectionContent {
    let type: String
    let id: String
    var name: String
    let visuals: Visual?
    var cover: [Cover]?
    let images: [Image]?
    var tracks: [Track]?
}
