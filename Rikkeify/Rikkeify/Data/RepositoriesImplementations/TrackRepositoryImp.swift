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
    func saveFavoriteTrack(_ track: Track) {
        localDataSource.saveFavoriteTrack(track)
    }
    
    func removeFavoriteTrack(_ track: Track) {
        localDataSource.removeFavoriteTrack(track)
    }
    
    func checkFavorite(track: Track, completion: @escaping (Result<Bool, Error>) -> Void) {
        localDataSource.checkFavorite(track: track, completion: completion)
    }
    
    func getAllFavoriteTracks() -> [Track] {
        localDataSource.getAllFavoriteTracks()
    }
    
    func downloadAudio(from link: URL, track: Track, completion: @escaping (Result<Void, any Error>) -> Void) {
        localDataSource.downloadAudio(from: link, track: track, completion: completion)
    }
    
    func getTrackMetadata(trackId: String, getAudio: Bool, completion: @escaping (Result<Track, NetworkError>) -> Void) {
        remoteDataSource.getTrackMetadata(trackId: trackId, getAudio: getAudio, completion: completion)
    }
    
    func getRecommendTracks(seedTrackId: String, completion: @escaping (Result<[RecommendTrack], NetworkError>) -> Void) {
        remoteDataSource.getRecommendTracks(seedTrackId: seedTrackId, completion: completion)
    }
}
