//
//  TrackRepository.swift
//  Rikkeify
//
//  Created by QuocLA on 08/05/2024.
//

import Foundation

protocol TrackRepository {
    func getTrackMetadata(trackId: String, getAudio: Bool, completion: @escaping (Result<Track, NetworkError>) -> Void)
    func getRecommendTracks(seedTrackId: String, completion: @escaping (Result<[RecommendTrack], NetworkError>) -> Void)
}
