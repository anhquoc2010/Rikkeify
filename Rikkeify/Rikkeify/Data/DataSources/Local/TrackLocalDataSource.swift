//
//  TrackLocalDataSource.swift
//  Rikkeify
//
//  Created by QuocLA on 21/05/2024.
//

import Foundation

protocol TrackLocalDataSource {
}

final class TrackLocalDataSourceImp {
    @Inject
    private var localService: RealmManager
}

extension TrackLocalDataSourceImp: TrackLocalDataSource {
}
