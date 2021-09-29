//
//  AudioInPlaylistViewController.swift
//  cloud_offline
//
//  Created by ThanhThanh on 20/08/2021.
//

import UIKit
import AVKit

class AudioInPlaylistViewController: UIViewController {

    
//MARK: -UI Components
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addBtn: UIButton?
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    //MARK: - Properties
    var songs = [Song]()
    var playlist = Playlist()
    var playlistVideo = PlaylistVideo()
    var position : Int = 0
    var type = 0
    var videos = [Video]()
    let sb = UIStoryboard(name: "Main", bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        addBtn?.layer.cornerRadius = 10 
        let nib = UINib(nibName: "UsualCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "UsualCollectionViewCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
        if type == 0 {
            titleLbl.text = "Your audios"
        }
        else {
            titleLbl.text = "Your videos"
        }

    }
    
    @IBAction func back(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        let vc = sb.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        present(vc, animated: false, completion: nil)
    }
    
    @IBAction func add(_ sender: Any) {
        if type == 0 {
            let vc = sb.instantiateViewController(withIdentifier: "AddNewPlaylistViewController") as! AddNewPlaylistViewController
            vc.screen = 1
            vc.type = 0
            vc.nowPlaylist = playlist
            present(vc, animated: true, completion: nil)
        }
        else {
            let vc = sb.instantiateViewController(withIdentifier: "AddNewPlaylistViewController") as! AddNewPlaylistViewController
            vc.screen = 1
            vc.type = 1
            vc.nowVideoPlaylist = playlistVideo
            present(vc, animated: true, completion: nil)
        }
        
    }
    @objc func didTapButton(sender : UIButton){
        let vc = sb.instantiateViewController(withIdentifier: "RemoveDialogViewController") as!
            RemoveDialogViewController
        vc.modalTransitionStyle = .coverVertical
        vc.modalPresentationStyle = .overFullScreen
        if type == 0 {
            vc.playlist = playlist
            vc.position = sender.tag
            vc.type = 0
        }
        else {
            vc.playlistVideo = playlistVideo
            vc.position = sender.tag
            vc.type = 1
        }
        self.present(vc, animated: true, completion: nil)
    }
    fileprivate func floatToString(x : NSInteger) -> String {
        let seconds = x % 60
        let minutes = (x / 60) % 60
        let hours = (x / 3600)
        if hours != 0 {
            return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
        }
        else {
            return String(format: "%0.2d:%0.2d",minutes,seconds)
        }

        
    }

}
extension AudioInPlaylistViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if type == 0 {
            return playlist.songs.count
        }
        else {
            return playlistVideo.videos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if type == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UsualCollectionViewCell", for: indexPath) as! UsualCollectionViewCell
            cell.label.text = playlist.songs[indexPath.item].name ?? "Unknown"
            cell.artistLbl.text = playlist.songs[indexPath.item].artistName ?? "Unknown"
            cell.image.image = playlist.songs[indexPath.item].artwork ?? UIImage(named: "unknown_music")
            cell.button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
            cell.button.tag = indexPath.item
            return cell
        }
        else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UsualCollectionViewCell", for: indexPath) as! UsualCollectionViewCell
            cell.label.text = playlistVideo.videos[indexPath.item].videoName ?? "Unknown"
            let str = UserDefaults.standard.string(forKey: "url")! + playlistVideo.videos[indexPath.item].urlString!
            let asset = AVAsset(url: URL(string: str)!)
            let duration = asset.duration
            let durationTime = CMTimeGetSeconds(duration)
            cell.artistLbl.text = floatToString(x: NSInteger(durationTime))
            cell.image.image = UIImage(named: "unknown_music")
            cell.button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
            cell.button.tag = indexPath.item
            return cell
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if type == 0 {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            vc.position = indexPath.item
            for i in 0..<playlist.songs.count{
                songs.append(playlist.songs[i])
            }
//            UserDefaults.standard.set(songs[position], forKey: (String)(indexPath.item%3))
//            print(UserDefaults.standard.object(forKey: (String)(indexPath.item%3)))
            vc.songs = songs            
            self.present(vc, animated: true, completion: nil)
        }
        else {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
            vc.position = indexPath.item
            for i in  0..<playlistVideo.videos.count{
                videos.append(playlistVideo.videos[i])
            }
            vc.videos = videos
            self.present(vc, animated: true, completion: nil)
        }
    }
}
extension AudioInPlaylistViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height/6)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 150, right: 10)
    }
}
