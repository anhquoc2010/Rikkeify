//
//  TrackRepository.swift
//  Rikkeify
//
//  Created by QuocLA on 08/05/2024.
//

import Foundation

protocol TrackRepository {
    func getTrackMetadata(trackId: String, completion: @escaping (Result<Track, NetworkError>) -> Void)
}
