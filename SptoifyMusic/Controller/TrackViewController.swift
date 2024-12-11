//
//  TrackViewController.swift
//  SptoifyMusic
//
//  Created by Виталий Сухинин on 10.12.2024.
//

import UIKit

class TrackViewController: UIViewController, TrackNetworkingDelegate {

    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    var trackId: String = ""
    var track: Track?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(trackId)
        NetworkingManager.shared.tracksDelegate = self
        NetworkingManager.shared.getTrack(trackId: trackId)
    }
    
    func networkingDidFinishWithTrack(track: Track) {
        DispatchQueue.main.async {
            
            self.track = track
            let durationInSeconds = track.duration_ms / 1000
            let durationInMinutes = durationInSeconds / 60
            var duration = ""
            
            duration.append(durationInMinutes > 0 ? "\(durationInMinutes) min " : "")
            duration.append("\(durationInSeconds % 60)s")
            
            self.nameLabel.text = track.name
            self.durationLabel.text = duration
            self.releaseDateLabel.text = track.album.release_date
            self.artistLabel.text = track.artists.map{$0.name}.joined(separator: ", ")
            
            
            if let icon = track.album.images.first {
                self.downloadIcon(url: icon.url)
            }
        }
    }
    
    func networkingDidFail() {
        print("Error")
    }
    
    func downloadIcon(url: String) {
        guard let url = URL(string: url) else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                
                let imgData = try Data(contentsOf: url)
                
                DispatchQueue.main.async {
                    self.image.image = UIImage(data: imgData)
                }
                
            } catch {
                print("Error downloading image: \(error)")
            }
        }
    }
    
    @IBAction func openSpotifyLink(_ sender: UIButton) {
        
        
        if let goodTrack = track {
            let urlString = goodTrack.album.external_urls.spotify
            
            guard let url = URL(string: urlString) else {
                    print("Invalid URL")
                    return
                }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)

        }
    }
    
}
