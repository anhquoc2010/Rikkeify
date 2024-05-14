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
    var sectionContent: SectionContent
    
    private let originalThumb: String
    private let originalName: String
    
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
    }
    
    func fetchSectionContent(completion: @escaping (Result<Void, NetworkError>) -> Void) {
        print("pushing: \(sectionContent.type) \(sectionContent.id)")
        sectionRepository.getSectionContents(type: sectionContent.type, id: sectionContent.id) { [weak self] (result: Result<SectionContent, NetworkError>) in
            guard let self = self else { return }
            switch result {
            case .success(let sectionContent):
                print(sectionContent)
                self.sectionContent = sectionContent
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
