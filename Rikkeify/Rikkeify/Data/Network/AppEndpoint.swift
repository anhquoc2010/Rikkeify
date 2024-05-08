//
//  AppEndpoint.swift
//  Rikkeify
//
//  Created by QuocLA on 08/05/2024.
//

import Foundation

enum AppEndpoint {
    case getTrack(trackId: String)
    case getTrackLyrics(trackId: String)
    case getTrackAudio(trackName: String)
}

extension AppEndpoint: EndPoint {
    var host: String {
        return "spotify-scraper.p.rapidapi.com"
    }
    
    var scheme: String {
        return "https"
    }
    
    var path: String {
        let prefix = "/v1"
        switch self {
        case .getTrack:
            return "\(prefix)/track/metadata"
        case .getTrackLyrics:
            return "\(prefix)/track/lyrics"
        case .getTrackAudio:
            return "\(prefix)/track/download/soundcloud"
        }
    }
    
    var method: RequestMethod {
        switch self {
        case .getTrack:
            return .get
        default:
            return .get
        }
    }
    
    var header: [String: String]? {
        return [
            "X-RapidAPI-Key": "b96f982db7msh9b782b0148df6c8p131f1djsn5c3f282ecda0",
            "X-RapidAPI-Host": "spotify-scraper.p.rapidapi.com"
        ]
    }
    
    var queryParams: [String : String]? {
        switch self {
        case .getTrack(let trackId):
            return ["trackId": trackId]
        case .getTrackLyrics(let trackId):
            return [
                "trackId": trackId,
                "format": "json",
                "removeNote": "false"
            ]
        case .getTrackAudio(let trackName):
            return ["track": trackName]
        }
    }
    
    var pathParams: [String : String]? {
        return nil
    }
    
    var body: [String: String]? {
        return nil
    }
}
