//
//  PlaylistTracksViewController.swift
//  SptoifyMusic
//
//  Created by Виталий Сухинин on 09.12.2024.
//

import UIKit

class PlaylistTracksViewController: UIViewController, PlaylistTracksNetworkingDelegate, UITableViewDelegate, UITableViewDataSource   {
    
    
    var playlistId: String = ""
    @IBOutlet weak var tableView: UITableView!
    var tracks: [Track] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        print(playlistId)
        NetworkingManager.shared.playlistTracksDelegate = self
        NetworkingManager.shared.getTracksByPlaylist(playlist: playlistId)
        
    }
    
    func networkingDidFinishWithPlaylistTracks(playlistTracks: PlaylistTracksResponse) {
        tracks = playlistTracks.items.map { $0.track }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = tracks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.artists.map{$0.name}.joined(separator: ", ")
        
        if let imageUrl = item.album.images.first?.url {
                    downloadIcon(url: imageUrl, imageView: cell.imageView)
                }
        
        return cell
    }
    
    func networkingDidFail() {
        print("Fail")
    }
    
    func downloadIcon(url: String, imageView: UIImageView?) {
        guard let url = URL(string: url) else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                
                let imgData = try Data(contentsOf: url)
                
                DispatchQueue.main.async {
                    if let imageView = imageView {
                        imageView.image = UIImage(data: imgData)
                    }
                }
            } catch {
                print("Error downloading image: \(error)")
            }
        }
    }
    


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
        let tvc = segue.destination as! TrackViewController
        
        let item = tracks[tableView.indexPathForSelectedRow!.row]
        tvc.trackId = item.id
        
    }

}
