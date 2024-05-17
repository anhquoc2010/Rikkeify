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
    var playback: PlaybackPresenter
    var sectionContent: SectionContent
    
    private let originalThumb: String
    private let originalName: String
    private let originalId: String
    
    var isPlayingThisSectionContent: Bool {
        originalId == playback.currentSectionContentId
    }
    
    var tracks: [Track] {
        sectionContent.tracks ?? []
    }
    
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
    }
    
    func fetchSectionContent(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        sectionRepository.getSectionContents(type: sectionContent.type, id: sectionContent.id) { [weak self] (result: Result<SectionContent, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let sectionContent):
                self.sectionContent = sectionContent
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func onTapPlayPauseButton(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        if isPlayingThisSectionContent {
            playback.togglePlayPauseState()
            completion(.success(()))
        } else {
            playback.tracks = tracks
            playback.playerItems = Array(repeating: nil, count: tracks.count)
            playback.playedIndex.removeAll()
            playback.currentTrackIndex = 0
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
}
