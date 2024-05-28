//
//  NetworkError.swift
//  Rikkeify
//
//  Created by QuocLA on 08/05/2024.
//

import Foundation

public enum NetworkError: Error {
    case decode
    case generic
    case invalidURL
    case noResponse
    case unauthorized
    case unexpectedStatusCode
    case unknown
    case getLyricError
    case getAudioError
    case expiredKey
    
    public var customMessage: String {
        switch self {
        case .decode:
            return "Decode Error"
        case .generic:
            return "Generic Error"
        case .invalidURL:
            return "Invalid URL Error"
        case .noResponse:
            return "No Response"
        case .unauthorized:
            return "Unauthorized URL"
        case .unexpectedStatusCode:
            return "Status Code Error"
        case .getLyricError:
            return "Could not get lyric"
        case .getAudioError:
            return "Could not get audio"
        case .expiredKey:
            return "Key was expired"
        default:
            return "Unknown Error"
        }
    }
}
