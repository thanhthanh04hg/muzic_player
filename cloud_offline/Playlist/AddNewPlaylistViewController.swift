//
//  AddNewPlaylistViewController.swift
//  cloud_offline
//
//  Created by ThanhThanh on 19/08/2021.
//

import UIKit

class AddNewPlaylistViewController: UIViewController {

    
    
    //MARK: -UI Components
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    //MARK: - Properties
    
    static var songs = RealmService.shared.load(listOf: Song.self)
    static var videos = RealmService.shared.load(listOf: Video.self)
    var playlistName : String = ""
    var flagAudio = Array(repeating: 0, count: songs.count)
    var flagVideo = Array(repeating: 0, count: videos.count)
    var screen : Int = 0
    var nowPlaylist = Playlist()
    var nowVideoPlaylist = PlaylistVideo()
    var type = 0
    var filterVideos = [Video]()
    var filterAudios = [Song]()
    var filterVideoData = [Video]()
    var filterAudioData = [Song]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let audiosNib = UINib(nibName: "AddCheckTableViewCell", bundle: nil)
        tableView.register(audiosNib, forCellReuseIdentifier: "AddCheckTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        if type == 0 {
            for i in 0..<AddNewPlaylistViewController.songs.count{
                filterAudios.append(AddNewPlaylistViewController.songs[i])
                filterAudioData.append(AddNewPlaylistViewController.songs[i])
            }
        }
        else{
            
            for i in 0..<AddNewPlaylistViewController.videos.count{
                filterVideos.append(AddNewPlaylistViewController.videos[i])
                filterVideoData.append(AddNewPlaylistViewController.videos[i])
            }
        }
    }

    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func submit(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        if screen == 0 {
            if type == 0 {
                let playlist = Playlist()
                
                for i in 0..<AddNewPlaylistViewController.songs.count {
                    if flagAudio[i] % 2 == 1 {
//                        playlist.songs.append(AddNewPlaylistViewController.songs[i])
                        playlist.songs.append(filterAudios[i])
                    }
                }
                playlist.playlistName = playlistName
                RealmService.shared.add(playlist)
            }
            else{
                let playlist = PlaylistVideo()
                
                for i in 0..<AddNewPlaylistViewController.videos.count {
                    if flagVideo[i] % 2 == 1 {
//                        playlist.videos.append(AddNewPlaylistViewController.videos[i])
                        playlist.videos.append(filterVideos[i])
                    }
                }
                playlist.playlistName = playlistName
                print(playlist)
                RealmService.shared.add(playlist)
            }
            
            
        }
        else{
            if type == 0 {
                for i in 0..<AddNewPlaylistViewController.songs.count {
                    if flagAudio[i] % 2 == 1 {
                        RealmService.shared.updateSong(playlist: nowPlaylist, song: filterAudios[i])
                    }
                }
            }
            else {
                for i in 0..<AddNewPlaylistViewController.videos.count {
                    if flagVideo[i] % 2 == 1 {
                        RealmService.shared.updateVideo(playlist: nowVideoPlaylist, video: filterVideos[i])
                    }
                }
            }
            
            
        }
        self.present(vc, animated: true, completion: nil)
       
    }
    func getSongs(){
        AddNewPlaylistViewController.songs = RealmService.shared.sort(by: UserDefaults.standard.integer(forKey: "AudioSortBy"))
        DispatchQueue.main.async() {
            self.tableView.reloadData()
        }
    }
    

}
extension AddNewPlaylistViewController :  UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == 0 {
            return filterAudios.count
        }
        else {
            return filterVideos.count
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
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddCheckTableViewCell") as! AddCheckTableViewCell
        cell.checkImage.image = UIImage(named: "Ellipse 61")
        if type == 0 {
            flagAudio[indexPath.item] = 0
        }
        else {
            flagVideo[indexPath.item] = 0
        }
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddCheckTableViewCell") as! AddCheckTableViewCell
        if type == 0 {
            cell.nameLbl.text = filterAudios[indexPath.item].name
            cell.artworkImage.image = filterAudios[indexPath.item].artwork ?? UIImage(named: "unknown_music")
            cell.artistLbl.text = filterAudios[indexPath.item].artistName
            if flagAudio[indexPath.item] % 2 == 1 {
                cell.checkImage.image = UIImage(named: "check")
            }
            else {
                cell.checkImage.image = UIImage(named: "Ellipse 61")
            }
        }
        else {

            cell.nameLbl.text = filterVideos[indexPath.item].videoName
            cell.artworkImage.image = UIImage(named: "unknown_music")
            cell.artistLbl.text = ""
            if flagVideo[indexPath.item] % 2 == 1 {
                cell.checkImage.image = UIImage(named: "check")
            }
            else {
                cell.checkImage.image = UIImage(named: "Ellipse 61")
            }
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(tableView.bounds.height/5)
    }
}
extension AddNewPlaylistViewController : UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if type == 0 {
            print(searchText)
            filterAudios = []
            if searchText == ""{
                for i in 0..<AddNewPlaylistViewController.songs.count{
                    filterAudios.append(AddNewPlaylistViewController.songs[i])
                }
            }
            else{
                for song in filterAudioData {
                    if song.name!.lowercased().contains(searchText.lowercased()){
                        filterAudios.append(song)
                    }
                }
            }
        }
        else {
            filterVideos = []
            
            if searchText == ""{
                for i in 0..<AddNewPlaylistViewController.videos.count{
                    filterVideos.append(AddNewPlaylistViewController.videos[i])
                }
            }
            else {
                for video in filterVideoData {
                    if video.videoName!.lowercased().contains(searchText.lowercased()){
                        filterVideos.append(video)
                    }
                }
            }
            
            
        }
        self.tableView.reloadData()
        
    }
}
