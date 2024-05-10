//
//  TrackRemoteDataSource.swift
//  Rikkeify
//
//  Created by QuocLA on 08/05/2024.
//

import Foundation

protocol TrackRemoteDataSource {
    func getTrackMetadata(trackId: String, getAudio: Bool, completion: @escaping (Result<Track, NetworkError>) -> Void)
    func getRecommendTracks(seedTrackId: String, completion: @escaping (Result<[RecommendTrack], NetworkError>) -> Void)
}

final class TrackRemoteDataSourceImp {
    @Inject
    private var networkService: Networkable
}

extension TrackRemoteDataSourceImp: TrackRemoteDataSource {
    func getRecommendTracks(seedTrackId: String, completion: @escaping (Result<[RecommendTrack], NetworkError>) -> Void) {
        networkService.sendRequest(endpoint: AppEndpoint.getRecommendTracks(seedTrackId: seedTrackId))
        { (result: Result<RecommendTracksResponseDTO, NetworkError>) in
            switch result {
            case .success(var recommendTracksResponseDTO):
                let group = DispatchGroup()
                
                for index in 0..<recommendTracksResponseDTO.tracks.count {
                    let recommendTrackDTO = recommendTracksResponseDTO.tracks[index]
                    
                    group.enter()
                    self.fetchTrackAudio(trackName: recommendTrackDTO.name) { result in
                        switch result {
                        case .failure(let error):
                            completion(.failure(error))
                        case .success(let audioResponseDTO):
                            recommendTracksResponseDTO.tracks[index].audio = audioResponseDTO
                        }
                        
                        group.leave()
                    }
                }
                
                group.notify(queue: .main) {
                    completion(.success(recommendTracksResponseDTO.tracks.map { $0.toDomain() }))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getTrackMetadata(trackId: String, getAudio: Bool, completion: @escaping (Result<Track, NetworkError>) -> Void) {
        networkService.sendRequest(endpoint: AppEndpoint.getTrack(trackId: trackId))
        { (result: Result<TrackResponseDTO, NetworkError>) in
            switch result {
            case .success(var trackResponseDTO):
                let group = DispatchGroup()
                
                group.enter()
                self.fetchTrackLyrics(trackId: trackResponseDTO.id) { result in
                    defer { group.leave() }
                    switch result {
                    case .failure(let error):
                        completion(.failure(error))
                    case .success(let lyricsResponseDTO):
                        trackResponseDTO.lyrics = lyricsResponseDTO
                    }
                }
                
                if getAudio {
                    group.enter()
                    self.fetchTrackAudio(trackName: trackResponseDTO.name) { result in
                        defer { group.leave() }
                        switch result {
                        case .failure(let error):
                            completion(.failure(error))
                        case .success(let audioResponseDTO):
                            trackResponseDTO.audio = audioResponseDTO
                        }
                    }
                }
                
                group.notify(queue: .main) {
                    completion(.success(trackResponseDTO.toDomain()))
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

extension TrackRemoteDataSourceImp {
    private func fetchTrackLyrics(trackId: String, completion: @escaping (Result<[LyricsResponseDTO], NetworkError>) -> Void) {
        networkService.sendRequest(endpoint: AppEndpoint.getTrackLyrics(trackId: trackId))
        { (result: Result<[LyricsResponseDTO], NetworkError>) in
            switch result {
            case .success(let lyricsResponseDTO):
                completion(.success(lyricsResponseDTO))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func fetchTrackAudio(trackName: String, completion: @escaping (Result<AudioTypeResponseDTO, NetworkError>) -> Void) {
        networkService.sendRequest(endpoint: AppEndpoint.getTrackAudio(trackName: trackName))
        { (result: Result<AudioTypeResponseDTO, NetworkError>) in
            switch result {
            case .success(let audioTypeResponseDTO):
                completion(.success(audioTypeResponseDTO))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
