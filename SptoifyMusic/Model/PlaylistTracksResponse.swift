//
//  PlaylistTracksResponse.swift
//  SptoifyMusic
//
//  Created by Виталий Сухинин on 09.12.2024.
//

import Foundation

import Foundation


struct PlaylistTracksResponse: Decodable {
    let href: String
    let limit: Int
    let total: Int
    let items: [TrackItem]
}

struct TrackItem: Decodable {
    let added_at: String
    let added_by: User
    let is_local: Bool
    let track: Track
}

struct User: Decodable {
    let href: String
    let id: String
    let type: String
    let uri: String
}

struct Track: Decodable {
    let album: Album
    let artists: [Artist]
    let available_markets: [String]
    let disc_number: Int
    let duration_ms: Int
    let explicit: Bool
    let href: String
    let id: String
    let name: String
    let popularity: Int
    let preview_url: String?
    let track_number: Int
    let type: String
    let uri: String
    let is_local: Bool
}

struct Album: Decodable {
    let album_type: String
    let total_tracks: Int
    let available_markets: [String]
    let href: String
    let id: String
    let images: [Image]
    let name: String
    let external_urls: ExternalUrls
    let release_date: String
    let release_date_precision: String
    let type: String
    let uri: String
    let artists: [Artist]
}

struct Artist: Decodable {
    let href: String
    let id: String
    let name: String
    let type: String
    let uri: String
}

