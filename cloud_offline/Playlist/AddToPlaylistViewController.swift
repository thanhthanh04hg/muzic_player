//
//  AddToPlaylistViewController.swift
//  cloud_offline
//
//  Created by ThanhThanh on 15/09/2021.
//

import UIKit
import RealmSwift
class AddToPlaylistViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var playlistAudios = RealmService.shared.load(listOf: Playlist.self)
    var playlistVideos = RealmService.shared.load(listOf: PlaylistVideo.self)
    var type = 0
    var flagAudio = Array(repeating: 0, count: RealmService.shared.load(listOf: Playlist.self).count)
    var flagVideo = Array(repeating: 0, count: RealmService.shared.load(listOf: PlaylistVideo.self).count)
    var song = Song()
    var video = Video()
    override func viewDidLoad() {
        super.viewDidLoad()

        let audiosNib = UINib(nibName: "AddCheckTableViewCell", bundle: nil)
        tableView.register(audiosNib, forCellReuseIdentifier: "AddCheckTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func submit(_ sender: Any) {
        if type == 0 {
            for i in 0..<playlistAudios.count{
                if flagAudio[i] % 2 == 1 {
                    let playlist = RealmService.shared.loadByFilter(listOf: Playlist.self, filter: "playlistName contains '"+(playlistAudios[i].playlistName!)+"'")
                    for i in 0..<playlist.count{
                        RealmService.shared.updateSong(playlist: playlist[i], song: song)
                        
                    }
                }
            }
        }
        else {
            for i in 0..<playlistVideos.count{
                if flagVideo[i] % 2 == 1 {
                    let playlist = RealmService.shared.loadByFilter(listOf: PlaylistVideo.self, filter: "playlistName contains '"+(playlistVideos[i].playlistName!)+"'")
                    for i in 0..<playlist.count{
                        RealmService.shared.updateVideo(playlist: playlist[i], video: video)
                        
                    }
                }
            }
        }
        dismiss(animated: true, completion: nil)
    }
    

}
extension AddToPlaylistViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == 0 {
            return playlistAudios.count
        }
        else {
            return playlistVideos.count
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == 0 {
            flagAudio[indexPath.item] += 1
        }
        else {
            flagVideo[indexPath.item] += 1
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddCheckTableViewCell") as! AddCheckTableViewCell
        if type == 0{
            cell.artworkImage.image = playlistAudios[indexPath.item].songs[0].artwork
            cell.nameLbl.text = playlistAudios[indexPath.item].playlistName
            cell.artistLbl.text = (String)(playlistAudios[indexPath.item].songs.count)
            if flagAudio[indexPath.item] % 2 == 1 {
                cell.checkImage.image = UIImage(named: "check")
            }
            else {
                cell.checkImage.image = UIImage(named: "Ellipse 61")
            }
        }
        else{
            cell.nameLbl.text = playlistVideos[indexPath.item].playlistName
            cell.artistLbl.text = (String)(playlistVideos[indexPath.item].videos.count)
            cell.artworkImage.image = UIImage(named: "unknown_music")
            if flagVideo[indexPath.item] % 2 == 1 {
                cell.checkImage.image = UIImage(named: "check")
            }
            else {
                cell.checkImage.image = UIImage(named: "Ellipse 61")
            }
        }
        return cell
    }
    
    
}
