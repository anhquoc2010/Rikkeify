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
    func getTracksAudio(trackNames: [String], completion: @escaping ([Audio]) -> Void)
    func saveFavoriteTrack(_ track: Track)
    func removeFavoriteTrack(_ track: Track)
    func checkFavorite(track: Track, completion: @escaping (Result<Bool, Error>) -> Void)
    func checkDownload(track: Track, completion: @escaping (Result<Bool, Error>) -> Void)
    func getAllFavoriteTracks() -> [Track]
    func getAllDownloadedTracks() -> [Track]
    func downloadAudio(from tracks: [Track], progressHandler: @escaping (Double) -> Void, completion: @escaping (Result<Void, Error>) -> Void)
    func removeAudio(from track: Track, completion: @escaping (Result<Void, Error>) -> Void)
}
