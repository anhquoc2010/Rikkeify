//
//  TrackLocalDataSource.swift
//  Rikkeify
//
//  Created by QuocLA on 21/05/2024.
//

import Foundation

enum DownloadError: Error {
    case trackNotFound
}

protocol TrackLocalDataSource {
    func saveFavoriteTrack(_ track: Track)
    func removeFavoriteTrack(_ track: Track)
    func checkFavorite(track: Track, completion: @escaping (Result<Bool, Error>) -> Void)
    func checkDownload(track: Track, completion: @escaping (Result<Bool, Error>) -> Void)
    func getAllFavoriteTracks() -> [Track]
    func getAllDownloadedTracks() -> [Track]
    func downloadAudio(from tracks: [Track], progressHandler: @escaping (Double) -> Void, completion: @escaping (Result<Void, Error>) -> Void)
    func removeAudio(from track: Track, completion: @escaping (Result<Void, Error>) -> Void)
}

final class TrackLocalDataSourceImp {
    @Inject
    private var localService: RealmManager
}

extension TrackLocalDataSourceImp: TrackLocalDataSource {
    func getAllDownloadedTracks() -> [Track] {
        // Fetch all RTrack objects
        let downloadedTrackObjects = localService.queryObjects(RTrack.self)
        
        // Filter downloaded tracks based on the presence of fileUrl in any RAudio object
        let filteredTracks = downloadedTrackObjects.filter { track in
            // Check if any RAudio object associated with the track has a non-nil and non-empty fileUrl
            return !(track.audio?.fileUrl.isEmpty ?? true)
        }
        
        // Convert filtered RTrack objects to Track domain objects
        return filteredTracks.map { $0.toDomain() }
    }
    
    func checkFavorite(track: Track, completion: @escaping (Result<Bool, Error>) -> Void) {
        let isFavorite = localService.queryObjects(RTrack.self)
            .filter("id == %@ AND isFavourited == true", track.id)
            .first != nil
        
        completion(.success(isFavorite))
    }
    
    func checkDownload(track: Track, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let track = localService.queryObjects(RTrack.self)
            .filter("id == %@", track.id)
            .first else {
            completion(.success(false))
            return
        }
        
        let isDownloaded = !(track.audio?.fileUrl.isEmpty ?? true)
        completion(.success(isDownloaded))
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
    
    func removeAudio(from track: Track, completion: @escaping (Result<Void, Error>) -> Void) {
        let group = DispatchGroup()
        let fileManager = FileManager.default
        
        guard let audioFormat = track.audio.first?.format else {
            // Handle case where audio format is missing for the track
            // This case should call the completion with a failure as no format is found
            completion(.failure(NSError(domain: "TrackErrorDomain", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Audio format is missing for the track"])))
            return
        }
        
        do {
            let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileName = "\(track.id).\(audioFormat)"
            let fileURL = documentsURL.appendingPathComponent(fileName)
            
            if fileManager.fileExists(atPath: fileURL.path) {
                group.enter()
                do {
                    try fileManager.removeItem(at: fileURL)
                    // Optionally, remove or update audio data reference in your data structure or database
                    try? localService.realm.write {
                        if let rTrack = localService.queryObjects(RTrack.self).filter("id == %@", track.id).first {
                            rTrack.audio?.fileUrl = ""
                        }
                    }
                    group.leave()
                } catch {
                    completion(.failure(error))
                    return
                }
            } else {
                // Handle case where file does not exist
                try? localService.realm.write {
                    if let rTrack = localService.queryObjects(RTrack.self).filter("id == %@", track.id).first {
                        rTrack.audio?.fileUrl = ""
                    }
                }
            }
        } catch {
            completion(.failure(error))
            return
        }
        
        group.notify(queue: .main) {
            completion(.success(()))
        }
    }
    
    func downloadAudio(from tracks: [Track], progressHandler: @escaping (Double) -> Void, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let track = tracks.first, let audioURLString = track.audio.first?.url, let audioURL = URL(string: audioURLString) else {
            // Handle case where audio URL is missing for a track
            let error = NSError(domain: "DownloadError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid or missing URL"])
            completion(.failure(error))
            return
        }
        let task = URLSession.shared.downloadTask(with: audioURL) { localURL, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let localURL = localURL else {
                let error = NSError(domain: "FileDownloader", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid local URL"])
                completion(.failure(error))
                return
            }
            
            do {
                let fileManager = FileManager.default
                let documentsURL = try fileManager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                // Ensure unique file name
                guard let format = track.audio.first?.format else {
                    let error = NSError(domain: "DownloadError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing format for track \(track.id)"])
                    completion(.failure(error))
                    return
                }
                let fileName = "\(track.id).\(format)"
                let uniqueFileName = self.uniqueFileName(for: fileName, in: documentsURL)
                let destinationURL = documentsURL.appendingPathComponent(uniqueFileName)
                
                if fileManager.fileExists(atPath: destinationURL.path) {
                    try fileManager.removeItem(at: destinationURL)
                }
                
                try fileManager.moveItem(at: localURL, to: destinationURL)
                
                // Update progress
                progressHandler(1)
                
                // Save or update audio
                self.saveOrUpdateAudio(for: track, savedURL: destinationURL)
                
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
        
        try? localService.realm.write {
            rTrack.isFavourited = isFavourited
        }
    }
    
    private func saveOrUpdateAudio(for track: Track, savedURL: URL) {
        try? localService.realm.write {
            if let rTrack = localService.queryObjects(RTrack.self).filter("id == %@", track.id).first {
                guard let audio = rTrack.audio else { return }
                rTrack.audio?.fileUrl = audio.fileUrl.isEmpty ? savedURL.absoluteString : ""
            } else {
                let rTrack = RTrack.fromDomain(track: track)
                rTrack.audio?.fileUrl = savedURL.absoluteString
                localService.realm.add(rTrack, update: .all)
            }
        }
    }
    
    private func uniqueFileName(for fileName: String, in directoryURL: URL) -> String {
        var newName = fileName
        var count = 1
        let fileExtension = URL(fileURLWithPath: fileName).pathExtension
        let fileNameWithoutExtension = URL(fileURLWithPath: fileName).deletingPathExtension().lastPathComponent
        
        while FileManager.default.fileExists(atPath: directoryURL.appendingPathComponent(newName).path) {
            newName = "\(fileNameWithoutExtension)_\(count).\(fileExtension)"
            count += 1
        }
        
        return newName
    }
}
