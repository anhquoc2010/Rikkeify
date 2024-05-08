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
}

extension TrackRepositoryImp: TrackRepository {
    func getTrackMetadata(trackId: String, completion: @escaping (Result<Track, NetworkError>) -> Void) {
        remoteDataSource.getTrackMetadata(trackId: trackId, completion: completion)
    }
}
