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
    case getSectionContent(type: String, id: String)
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
        case .getSectionContent(let type, _):
            switch type {
            case ItemType.album.rawValue:
                return "\(prefix)/album/tracks"
            case ItemType.playlist.rawValue:
                return "\(prefix)/playlist/contents"
            case ItemType.artist.rawValue:
                return "\(prefix)/artist/overview"
            default:
                return ""
            }
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
                "X-RapidAPI-Key": "bc88b64601mshc107a8c10935db7p16149bjsn718883352220",
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
        case .getSectionContent(let type, let id):
            switch type {
            case ItemType.album.rawValue:
                return [
                    "albumId": id
                ]
            case ItemType.playlist.rawValue:
                return [
                    "playlistId": id
                ]
            case ItemType.artist.rawValue:
                return [
                    "artistId": id
                ]
            default:
                return nil
            }
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
