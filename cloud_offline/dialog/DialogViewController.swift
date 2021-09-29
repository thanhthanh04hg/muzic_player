//
//  DialogViewController.swift
//  cloud_offline
//
//  Created by ThanhThanh on 12/08/2021.
//

import UIKit

class DialogViewController: UIViewController {
//MARK: -UI Components
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var playBtn: UIButton!
    
    @IBOutlet weak var tappableView: UIView!
    
    //MARK: -Properties
    var playCase : AudioViewBy = .track
    var playlist = Playlist()
    var songs = [Song]()
    var albums = [Album]()
    var videos = [Video]()
    var playlistVideo = PlaylistVideo()
    var type : Int = 0
    var onReloadCollectionView : (() -> Void)?
    public var position: Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize Tap Gesture Recognizer
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapView(_:)))

        // Add Tap Gesture Recognizer
        tappableView.addGestureRecognizer(tapGestureRecognizer)


    }
    override func viewWillAppear(_ animated: Bool) {
        switch playCase {
        case .track:
            if type == 0 {
                deleteBtn.setTitle("      Delete music", for: .normal)
                addBtn.setTitle("      Add to playlist", for: .normal)
                addBtn.setImage(UIImage(named: "ic_add"), for: .normal)
                playBtn.setTitle("      Play music", for: .normal)
            }
            else {
                deleteBtn.setTitle("      Delete video", for: .normal)
                addBtn.setTitle("      Add to playlist", for: .normal)
                addBtn.setImage(UIImage(named: "ic_add"), for: .normal)
                playBtn.setTitle("      Play video", for: .normal)
            }
                        
        case .playlist:
            deleteBtn.setTitle("      Delete playlist", for: .normal)
            addBtn.setTitle("      Rename playlist", for: .normal)
            addBtn.setImage(UIImage(named: "ic_rename"), for: .normal)
            playBtn.setTitle("      Play all", for: .normal)
        case .album:
            print(albums)
        }
    }
    
    
    @objc func didTapView(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onDelete(_ sender: Any) {
        if type == 0 {
            let sb = UIStoryboard(name: "Main", bundle: nil)
            switch playCase {
            case .track:
                RealmService.shared.delete(songs[position])
                let vc = sb.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                self.present(vc, animated: false, completion: nil)
            case .playlist:
                RealmService.shared.delete(playlist)
                let vc = sb.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                self.present(vc, animated: false, completion: nil)
            case .album:
                print("album")
            }
            
        }
        else {
            switch playCase {
            case .track:
                RealmService.shared.delete(videos[position])
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                self.present(vc, animated: false, completion: nil)
            case .playlist:
                RealmService.shared.delete(playlistVideo)
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                self.present(vc, animated: false, completion: nil)
            case .album:
                print("album")
            }
        }
        
//        dismiss(animated: true, completion: nil)
    }
    @IBAction func onPlay(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        if type == 0 {
            let vc = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            switch playCase {
            case .track:
                vc.songs = songs
                vc.position = position
            case .playlist:
                for i in 0..<playlist.songs.count{
                    songs.append(playlist.songs[i])
                }
                vc.songs = songs
                vc.position = 0
            case .album:
                print("album")
            }
            self.present(vc, animated: true, completion: nil)
        }
        else {
            let vc = sb.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
            switch playCase {
            case .track:
                vc.videos = videos
                vc.position = position
            case .playlist:
                for i in 0..<playlistVideo.videos.count{
                    videos.append(playlistVideo.videos[i])
                }
                
                vc.videos = videos
                vc.position = 0
                print("playlist")
            case .album:
                print("album")
            }
            self.present(vc, animated: true, completion: nil)
        }

        
        
    }
    
    @IBAction func onAddToPlaylist(_ sender: Any) {
        if type == 0 {
            switch playCase {
            case .track:
//                self.dismiss(animated: true, completion: nil)
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let addToPlaylistVC = sb.instantiateViewController(withIdentifier: "AddToPlaylistViewController") as! AddToPlaylistViewController
                addToPlaylistVC.song = songs[position]
                addToPlaylistVC.type = 0
                present(addToPlaylistVC, animated: true, completion: nil)
                
            case .playlist:
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let newPlaylistVC = sb.instantiateViewController(withIdentifier: "NewPlaylistDialogViewController") as! NewPlaylistDialogViewController
                newPlaylistVC.flag = 1
                newPlaylistVC.type = 0
                newPlaylistVC.position = position
                newPlaylistVC.titleStr = "Rename playlist"
                newPlaylistVC.placeholderStr = playlist.playlistName!
                newPlaylistVC.modalPresentationStyle = .overFullScreen
                newPlaylistVC.modalTransitionStyle = .coverVertical
                present(newPlaylistVC, animated: true, completion: nil)
                
            default:
                print("default")
            }
        }
        else {
            switch playCase {
            case .track:
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let addToPlaylistVC = sb.instantiateViewController(withIdentifier: "AddToPlaylistViewController") as! AddToPlaylistViewController
                addToPlaylistVC.type = 1
                addToPlaylistVC.video = videos[position]
                present(addToPlaylistVC, animated: true, completion: nil)
            case .playlist:
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let newPlaylistVC = sb.instantiateViewController(withIdentifier: "NewPlaylistDialogViewController") as! NewPlaylistDialogViewController
                newPlaylistVC.flag = 1
                newPlaylistVC.type = 1
                newPlaylistVC.position = position
                newPlaylistVC.placeholderStr = playlistVideo.playlistName!
                newPlaylistVC.titleStr = "Rename playlist"
                newPlaylistVC.modalPresentationStyle = .overFullScreen
                newPlaylistVC.modalTransitionStyle = .coverVertical
                present(newPlaylistVC, animated: true, completion: nil)
                
            default:
                print("default")
            }
        }
        
    }
    @IBAction func handleCloseButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
