import Foundation

struct PlaylistResponse: Decodable {
    let playlists: Playlists
}

struct Playlists: Decodable {
//    let href: String
//    let limit: Int
//    let next: String?
//    let offset: Int
//    let previous: String?
//    let total: Int
    let items: [Item?]
}

struct Item: Decodable {
    let collaborative: Bool
    let description: String
//    let external_urls: ExternalUrls
//    let href: String
    let id: String
    let images: [Image]
    let name: String
    let owner: Owner
    let snapshot_id: String
    let tracks: Tracks
    let type: String
    let uri: String
    let primary_color: String?
}


struct ExternalUrls: Decodable {
    let spotify: String
}

struct Image: Decodable {
    let url: String
    let height: Int?
    let width: Int?
}

struct Owner: Decodable {
//    let external_urls: ExternalUrls
    let href: String
    let id: String
    let type: String
//    let uri: String
    let display_name: String?
}

struct Tracks: Decodable {
    let href: String
    let total: Int
}
