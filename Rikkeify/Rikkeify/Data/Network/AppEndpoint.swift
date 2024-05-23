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
    case getExplore
    case search(query: String, type: String, numberOfTopResults: Int)
    case getGenreContents(genreId: String)
}

extension AppEndpoint: EndPoint {
    var host: String {
        switch self {
        case .getRecommendTracks, .getExplore, .search:
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
        case .getExplore:
            return "/browse_all/"
        case .search:
            return "/search/"
        case .getGenreContents:
            return "\(prefix)/genre/contents"
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
        case .getRecommendTracks, .getExplore, .search:
            return [
                "X-RapidAPI-Key": "78104f7c39msh80dd944199e6482p1a97e0jsn923e0159ca6e",
                "X-RapidAPI-Host": "spotify23.p.rapidapi.com"
            ]
        default:
            return [
                "X-RapidAPI-Key": "4ab51ba4ccmsh438884665e7462fp1ff5ffjsn0e5325498fa1",
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
        case .search(let query, let type, let numberOfTopResults):
            return [
                "q": query,
                "type": type,
                "numberOfTopResults": String(numberOfTopResults)
            ]
        case .getGenreContents(let genreId):
            return [
                "genreId": genreId
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
