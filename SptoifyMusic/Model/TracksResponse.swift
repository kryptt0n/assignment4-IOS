//
//  TracksResponse.swift
//  SptoifyMusic
//
//  Created by Виталий Сухинин on 10.12.2024.
//

import Foundation

struct TracksResponse: Decodable {
    var tracks: TrackResponseContent
}

struct TrackResponseContent: Decodable {
    var items: [Track]
}
