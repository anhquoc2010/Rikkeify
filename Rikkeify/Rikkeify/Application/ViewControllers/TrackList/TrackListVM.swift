//
//  TrackListVM.swift
//  Rikkeify
//
//  Created by PearUK on 14/5/24.
//

import Foundation

class TrackListVM {
    @Inject
    private var sectionRepository: SectionRepository
    @Inject
    private var trackRepository: TrackRepository
    
    @Inject
    var playback: PlaybackPresenter
    var sectionContent: SectionContent
    
    private let originalThumb: String
    private let originalName: String
    private let originalId: String
    
    var isFavorite: Bool = false
    
    var isPlayingThisSectionContent: Bool {
        originalId == playback.currentSectionContentId
    }
    
    var tracks = [Track]()
    
    var thumbImage: String {
        sectionContent.cover?.first?.url
        ?? sectionContent.images?.first?.url
        ?? sectionContent.visuals?.avatar.first?.url
        ?? originalThumb
    }
    
    var titleName: String {
        sectionContent.name == "" ? originalName : sectionContent.name
    }
    
    init(sectionContent: SectionContent) {
        self.sectionContent = sectionContent
        self.originalThumb = sectionContent.cover?.first?.url
        ?? sectionContent.images?.first?.url
        ?? sectionContent.visuals?.avatar.first?.url
        ?? ""
        self.originalName = sectionContent.name
        self.originalId = sectionContent.id
        switch sectionContent.type {
        case "liked":
            tracks = trackRepository.getAllFavoriteTracks()
        case "downloaded":
            tracks = trackRepository.getAllDownloadedTracks()
        default:
            tracks = sectionContent.tracks ?? []
        }
    }
    
    func fetchSectionContent(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        if sectionContent.id != "likedlist" && sectionContent.id != "downloadedlist" {
            sectionRepository.getSectionContents(type: sectionContent.type, id: sectionContent.id) { [weak self] (result: Result<SectionContent, NetworkError>) in
                guard let self = self else { return }
                switch result {
                case .success(let sectionContent):
                    self.sectionContent = sectionContent
                    self.tracks = sectionContent.tracks ?? []
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } else {
            completion(.success(()))
        }
    }
    
    func onTapPlayPauseButton(index: Int = 0, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        if isPlayingThisSectionContent {
            playback.togglePlayPauseState()
//            completion(.success(()))
        } else {
            playback.tracks = tracks
            playback.playerItems = Array(repeating: nil, count: tracks.count)
            playback.playedIndex.removeAll()
            playback.currentTrackIndex = index
            playback.fetchTrackMetadata(index: playback.currentTrackIndex) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success:
                    self.playback.currentSectionContentId = originalId
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    //    func saveOrRemoveFavourite() {
    //        checkFavorite() { [weak self] result in
    //            guard let self = self else { return }
    //            switch result {
    //            case .success():
    //                if self.isFavorite {
    //                    self.isFavorite = false
    //                    self.trackRepository.removeFavoriteTrack(playback.currentTrack)
    //                } else {
    //                    self.isFavorite = true
    //                    self.trackRepository.saveFavoriteTrack(playback.currentTrack)
    //                }
    //            case .failure:
    //                break
    //            }
    //        }
    //    }
    
    //    func checkFavorite(completion: @escaping (Result<Void, Error>) -> Void) {
    //        trackRepository.checkFavorite(track: playback.currentTrack) { [weak self] result in
    //            guard let self = self else { return }
    //            switch result {
    //            case .success(let isFavorite):
    //                self.isFavorite = isFavorite
    //                completion(.success(()))
    //            case .failure(let error):
    //                completion(.failure(error))
    //            }
    //        }
    //    }
}
