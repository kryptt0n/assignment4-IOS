//
//  TrackListViewController.swift
//  SptoifyMusic
//
//  Created by Виталий Сухинин on 10.12.2024.
//

import UIKit

class TrackListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TrackListNetworkingDelegate, UISearchBarDelegate{
    
    var tracks: [Track] = []
    @IBOutlet weak var tableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkingManager.shared.trackListDelegate = self
        NetworkingManager.shared.getTrackList(trackName: "New year")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tracks.count
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 2 {
            NetworkingManager.shared.getTrackList(trackName: searchText)
            return
        }
        NetworkingManager.shared.getTrackList(trackName: "Christmas")

    }
    
    func networkingDidFinishWithTrackList(trackList: TracksResponse) {
        tracks = trackList.tracks.items
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
