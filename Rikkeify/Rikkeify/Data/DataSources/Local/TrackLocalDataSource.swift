//
//  TrackLocalDataSource.swift
//  Rikkeify
//
//  Created by QuocLA on 21/05/2024.
//

import Foundation

protocol TrackLocalDataSource {
    func saveFavoriteTrack(_ track: Track)
    func removeFavoriteTrack(_ track: Track)
    func checkFavorite(track: Track, completion: @escaping (Result<Bool, Error>) -> Void)
    func getAllFavoriteTracks() -> [Track]
    func downloadAudio(from link: URL, track: Track, completion: @escaping (Result<Void, Error>) -> Void)
}

final class TrackLocalDataSourceImp {
    @Inject
    private var localService: RealmManager
}

extension TrackLocalDataSourceImp: TrackLocalDataSource {
    func checkFavorite(track: Track, completion: @escaping (Result<Bool, Error>) -> Void) {
        let isFavorite = localService.queryObjects(RTrack.self)
            .filter("id == %@ AND isFavourited == true", track.id)
            .first != nil
        
        completion(.success(isFavorite))
    }
    
    func saveFavoriteTrack(_ track: Track) {
        let rTrack = RTrack.fromDomain(track: track)
        rTrack.isFavourited = true
        localService.saveObject(rTrack)
    }
    
    func removeFavoriteTrack(_ track: Track) {
        updateTrack(track, isFavourited: false)
    }
    
    func getAllFavoriteTracks() -> [Track] {
        let rTracks = localService.queryObjects(RTrack.self).filter("isFavourited == true")
        return rTracks.map { $0.toDomain() }
    }
    
    func downloadAudio(from link: URL, track: Track, completion: @escaping (Result<Void, Error>) -> Void) {
        let task = URLSession.shared.downloadTask(with: link) { (tempURL, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let tempURL = tempURL else {
                let error = NSError(domain: "DownloadError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to download file"])
                completion(.failure(error))
                return
            }
            
            do {
                let fileManager = FileManager.default
                let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let savedURL = documentsURL.appendingPathComponent(link.lastPathComponent)
                try fileManager.moveItem(at: tempURL, to: savedURL)
                
                self.saveOrUpdateAudio(for: track, savedURL: savedURL)
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

extension TrackLocalDataSourceImp {
    private func updateTrack(_ track: Track, isFavourited: Bool) {
        guard let rTrack = localService.queryObjects(RTrack.self).filter("id == %@", track.id).first else { return }
        
        let hasNilFileUrl = rTrack.audio.contains { $0.fileUrl.isEmpty }
        if hasNilFileUrl {
            localService.deleteObject(rTrack)
        } else {
            try? localService.realm.write {
                rTrack.isFavourited = isFavourited
            }
        }
    }
    
    private func saveOrUpdateAudio(for track: Track, savedURL: URL) {
        try? localService.realm.write {
            if let rTrack = localService.queryObjects(RTrack.self).filter("id == %@", track.id).first {
                if let existingAudio = rTrack.audio.first(where: { $0.fileUrl == savedURL.absoluteString }) {
                    existingAudio.fileUrl = savedURL.absoluteString
                } else {
                    rTrack.audio.append(RAudio(value: ["fileUrl": savedURL.absoluteString]))
                }
            } else {
                let rTrack = RTrack(value: ["id": track.id])
                rTrack.audio.append(RAudio(value: ["fileUrl": savedURL.absoluteString]))
                localService.realm.add(rTrack)
            }
        }
    }
}
