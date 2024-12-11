//
//  ViewController.swift
//  SptoifyMusic
//
//  Created by Виталий Сухинин on 06.12.2024.
//

import UIKit

class ViewController: UIViewController, PlaylistNetworkingDelegate, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    
    
    @IBOutlet weak var genreSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var genreList: [String] = []
    var playlists: [Item] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkingManager.shared.playlistDelegate = self
        NetworkingManager.shared.getPlaylist(genre: "christmas  ")
    }
    
    func networkingDidFinishWithPlaylist(playlist: PlaylistResponse) {
        playlists = playlist.playlists.items.compactMap { $0 }
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func networkingDidFail() {
        print("fail")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 2 {
            NetworkingManager.shared.getPlaylist(genre: searchText)
            return
        }
        NetworkingManager.shared.getPlaylist(genre: "all")
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = playlists[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
        
        
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = item.description
        
        if let imageUrl = item.images.first?.url {
                    downloadIcon(url: imageUrl, imageView: cell.imageView)
                }
        
        return cell
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
        let pvc = segue.destination as! PlaylistTracksViewController
        
        let item = playlists[tableView.indexPathForSelectedRow!.row]
        pvc.playlistId = item.id
    }



}

