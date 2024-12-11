import Foundation

protocol NetworkingDelegate {
    func networkingDidFail()
}

protocol TokenNetworkingDelegate: NetworkingDelegate {
    func networkingDidFinishWithToken(token: AccessToken)
}

protocol GenresNetworkingDelegate: NetworkingDelegate {
    func networkingDidFinishWithGenres(genres: GenreList)
}

protocol PlaylistNetworkingDelegate: NetworkingDelegate {
    func networkingDidFinishWithPlaylist(playlist: PlaylistResponse)
}

protocol PlaylistTracksNetworkingDelegate: NetworkingDelegate {
    func networkingDidFinishWithPlaylistTracks(playlistTracks: PlaylistTracksResponse)
}

protocol TrackNetworkingDelegate: NetworkingDelegate {
    func networkingDidFinishWithTrack(track: Track)
}

protocol TrackListNetworkingDelegate: NetworkingDelegate {
    func networkingDidFinishWithTrackList(trackList: TracksResponse)
}

class NetworkingManager {
    
    static var shared = NetworkingManager()
    var tokenDelegate: TokenNetworkingDelegate?
    var genreDelegate: GenresNetworkingDelegate?
    var playlistDelegate: PlaylistNetworkingDelegate?
    var playlistTracksDelegate: PlaylistTracksNetworkingDelegate?
    var tracksDelegate: TrackNetworkingDelegate?
    var trackListDelegate: TrackListNetworkingDelegate?
    
    
    func getGenres() {
        let url = "https://api.spotify.com/v1/recommendations/available-genre-seeds"
        

        getData(
                url,
                of: GenreList.self,
                successFunc: { genreList in
                    self.genreDelegate!.networkingDidFinishWithGenres(genres: genreList)
                },
                failureFunc: { error in
                    print("Error: \(error.localizedDescription)")
                }
            )

    }
    
    func getPlaylist(genre: String) {
        let url = "https://api.spotify.com/v1/search?q=\(genre)&type=playlist"
        
        getData(
                url,
                of: PlaylistResponse.self,
                successFunc: { playlist in
                    self.playlistDelegate!.networkingDidFinishWithPlaylist(playlist: playlist)
                },
                failureFunc: { error in
                    print("Error: \(error.localizedDescription)")
                }
            )
    }
    
    func getTracksByPlaylist(playlist: String) {
        let url = "https://api.spotify.com/v1/playlists/\(playlist)/tracks"
        
        getData(
                url,
                of: PlaylistTracksResponse.self,
                successFunc: { playlistTracks in
                    self.playlistTracksDelegate!.networkingDidFinishWithPlaylistTracks(playlistTracks: playlistTracks)
                },
                failureFunc: { error in
                    print("Error: \(error.localizedDescription)")
                }
            )
        
    }
    
    func getTrack(trackId: String) {
        let url = "https://api.spotify.com/v1/tracks/\(trackId)"
        

        getData(
                url,
                of: Track.self,
                successFunc: { track in
                    self.tracksDelegate!.networkingDidFinishWithTrack(track: track)
                },
                failureFunc: { error in
                    print("Error: \(error.localizedDescription)")
                }
            )

    }
    
    func getTrackList(trackName: String) {
        let url = "https://api.spotify.com/v1/search?q=\(trackName)&type=track"
        

        getData(
                url,
                of: TracksResponse.self,
                successFunc: { trackList in
                    self.trackListDelegate?.networkingDidFinishWithTrackList(trackList: trackList)
                },
                failureFunc: { error in
                    print("Error: \(error.localizedDescription)")
                }
            )

    }
    
    func getData<T: Decodable>(
        _ urlParam: String,
        of type: T.Type,
        successFunc: @escaping (T) -> Void,
        failureFunc: @escaping (Error) -> Void
    ) {
        guard let url = URL(string: urlParam) else {
            print("Invalid URL: \(urlParam)")
            return
        }
        
        var request = URLRequest(url: url)
        print(url)
        
        
        let token = CoreDataManager.shared.getToken()
        
        guard let goodToken = token, let tokenType = goodToken.tokenType, let tokenValue = goodToken.value else {
            print("Failed to retrieve token")
            return
        }
        
        request.setValue("\(tokenType) \(tokenValue)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                failureFunc(error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                failureFunc(NSError(domain: "InvalidResponse", code: -1, userInfo: nil))
                return
            }
            
            
            guard let goodData = data else {
                failureFunc(NSError(domain: "NoData", code: -1, userInfo: nil))
                return
            }
            
            do {
                let decodedObject = try JSONDecoder().decode(type, from: goodData)
                successFunc(decodedObject)
            } catch {
                failureFunc(error)
            }
        }
        
        task.resume()
    }
    
    func getToken() {
        let url = URL(string: "https://accounts.spotify.com/api/token")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let parameters: [String: String] = [
            "client_id": "65ee357cb2d346aeb21d132cc1ee6e5d",
            "client_secret": "34775b31911148af84e466d25b0e2612",
            "grant_type": "client_credentials"
        ]

        let body = parameters
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")

        request.httpBody = body.data(using: .utf8)


        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {// handle, then...return}
                               print(error)
                               return
                       }
            guard let httpResponse =
                               response as? HTTPURLResponse,(200...299).contains(httpResponse.statusCode)
                       else {
                           return
                       }

            if let goodData = data {

                let decoder = JSONDecoder()
                do {
                    let token = try decoder.decode(AccessToken.self, from: goodData)
                    self.tokenDelegate?.networkingDidFinishWithToken(token: token)
                }catch {
                    print(error)

                }
            }
        }
        
        task.resume()
        
    }
    
}
