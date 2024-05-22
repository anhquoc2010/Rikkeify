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
    func saveFavoriteTrack(_ track: Track)
    func removeFavoriteTrack(_ track: Track)
    func checkFavorite(track: Track, completion: @escaping (Result<Bool, Error>) -> Void)
    func getAllFavoriteTracks() -> [Track]
    func downloadAudio(from link: URL, track: Track, completion: @escaping (Result<Void, Error>) -> Void)
}
