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
    case getRecommendTracks(seedTrackId: String)
    case getSections
}

extension AppEndpoint: EndPoint {
    var host: String {
        switch self {
        case .getRecommendTracks:
            return "spotify23.p.rapidapi.com"
        default:
            return "spotify-scraper.p.rapidapi.com"
        }
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
        case .getRecommendTracks:
            return "/recommendations/"
        case .getSections:
            return "\(prefix)/home"
        }
    }
    
    var method: RequestMethod {
        switch self {
        default:
            return .get
        }
    }
    
    var header: [String: String]? {
        switch self {
        case .getRecommendTracks:
            return [
                "X-RapidAPI-Key": "0e5d740037mshed0caed0971851bp1d95c7jsn0baa1414a7b3",
                "X-RapidAPI-Host": "spotify23.p.rapidapi.com"
            ]
        default:
            return [
                "X-RapidAPI-Key": "afaca2579dmsh1fcf68f80862231p175e2fjsn2a17e3665d6b",
                "X-RapidAPI-Host": "spotify-scraper.p.rapidapi.com"
            ]
        }
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
        case .getRecommendTracks(let seedTrackId):
            return [
                "limit": "5",
                "seed_tracks": seedTrackId
            ]
        default:
            return nil
        }
    }
    
    var pathParams: [String : String]? {
        return nil
    }
    
    var body: [String: String]? {
        return nil
    }
}
