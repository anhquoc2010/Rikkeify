//
//  TrackRepositoryImp.swift
//  Rikkeify
//
//  Created by QuocLA on 08/05/2024.
//

import Foundation
import Swinject

final class TrackRepositoryImp {
    @Inject
    private var remoteDataSource: TrackRemoteDataSource!
    @Inject
    private var localDataSource: TrackLocalDataSource!
}

extension TrackRepositoryImp: TrackRepository {
    func getAllDownloadedTracks() -> [Track] {
        localDataSource.getAllDownloadedTracks()
    }
    
    func saveFavoriteTrack(_ track: Track) {
        localDataSource.saveFavoriteTrack(track)
    }
    
    func removeFavoriteTrack(_ track: Track) {
        localDataSource.removeFavoriteTrack(track)
    }
    
    func checkFavorite(track: Track, completion: @escaping (Result<Bool, Error>) -> Void) {
        localDataSource.checkFavorite(track: track, completion: completion)
    }
    
    
    func checkDownload(track: Track, completion: @escaping (Result<Bool, Error>) -> Void) {
        localDataSource.checkDownload(track: track, completion: completion)
    }
    
    func getAllFavoriteTracks() -> [Track] {
        localDataSource.getAllFavoriteTracks()
    }
    
    func downloadAudio(from tracks: [Track], progressHandler: @escaping (Double) -> Void, completion: @escaping (Result<Void, Error>) -> Void) {
        localDataSource.downloadAudio(from: tracks, progressHandler: progressHandler, completion: completion)
    }
    
    func removeAudio(from track: Track, completion: @escaping (Result<Void, Error>) -> Void) {
        localDataSource.removeAudio(from: track, completion: completion)
    }
    
    func getTrackMetadata(trackId: String, getAudio: Bool, completion: @escaping (Result<Track, NetworkError>) -> Void) {
        checkDownload(track: Track(id: trackId, name: "", shareUrl: "", durationMs: 0, durationText: "", trackNumber: nil, playCount: nil, artists: [], album: nil, lyrics: [], audio: []), completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let isDownloaded):
                if isDownloaded, let track = self.getAllDownloadedTracks().first(where: { $0.id == trackId }) {
                    completion(.success(track))
                } else {
                    remoteDataSource.getTrackMetadata(trackId: trackId, getAudio: getAudio, completion: completion)
                }
            case .failure:
                remoteDataSource.getTrackMetadata(trackId: trackId, getAudio: getAudio, completion: completion)
            }
        })
    }
    
    func getRecommendTracks(seedTrackId: String, completion: @escaping (Result<[RecommendTrack], NetworkError>) -> Void) {
        remoteDataSource.getRecommendTracks(seedTrackId: seedTrackId, completion: completion)
    }
    
    func getTracksAudio(trackNames: [String], completion: @escaping ([Audio]) -> Void) {
        remoteDataSource.getTracksAudio(trackNames: trackNames, completion: completion)
    }
}
