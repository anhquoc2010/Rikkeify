//
//  TrackViewVM.swift
//  Rikkeify
//
//  Created by PearUK on 7/5/24.
//

import AVFoundation

class TrackViewVM {
    @Inject
    var playback: PlaybackPresenter
    
//    func fetchRecommendTracks(completion: @escaping (Result<Void, NetworkError>) -> Void) {
//        trackRepository.getRecommendTracks(seedTrackId: tracks[currentTrackIndex].id) { [weak self] (result: Result<[RecommendTrack], NetworkError>) in
//            guard let self = self else { return }
//            switch result {
//            case .success(let recommendTracks):
//                self.recommendTracks = recommendTracks
//                let newTracks = recommendTracks.map { $0.audio[0] }
//                self.addTracksToQueue(tracks: newTracks)
//                checkplayerItems()
//                completion(.success(()))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//        
//        func checkplayerItems() {
//            guard let _ = self.player else {
//                print("Player is not initialized.")
//                return
//            }
//            print("Items in player queue:")
//            for index in 0..<playerItems.count {
//                let item = playerItems[index]
//                print("Item \(index + 1): \(item.asset)")
//            }
//        }
//    }
    
//    func preFetchNextTrackMetadata(completion: @escaping (Result<Void, NetworkError>) -> Void) {
//        trackRepository.getTrackMetadata(trackId: recommendTracks[currentTrackIndex <= recommendTracks.count ? currentTrackIndex : currentTrackIndex - (5 * (tracks.count / 5))].id, getAudio: true) { [weak self] (result: Result<Track, NetworkError>) in
//            guard let self = self else { return }
//            switch result {
//            case .success(var track):
//                track.audio = recommendTracks[0].audio
//                self.tracks.append(track)
//                print(tracks)
//                completion(.success(()))
//            case .failure(let error):
//                completion(.failure(error))
//            }
//        }
//    }
}
