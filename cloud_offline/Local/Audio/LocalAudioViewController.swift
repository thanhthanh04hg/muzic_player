//
//  LocalAudioViewController.swift
//  cloud_offline
//
//  Created by ThanhThanh on 10/08/2021.
//

import UIKit
import SCLAlertView



class LocalAudioViewController: UIViewController {

    //MARK: UI Components
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK: Properties
    
    var songs = RealmService.shared.load(listOf: Song.self)
    var albums = [Album]()
    public var position : Int = 0
    var playlists = RealmService.shared.load(listOf: Playlist.self)
    private var sortBy: AudioSortBy = .az
    private var viewBy : AudioViewBy = .track
    var recentSongs = RealmService.shared.get(RecentAudio.self, filter: "name contains 'Recent Audio'")

    let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        UserDefaults.standard.set(dir?.description, forKey: "url")
    }
    override func viewDidAppear(_ animated: Bool) {
        reloadListMusic()

    }
    override func viewWillAppear(_ animated: Bool) {
        playlists = RealmService.shared.load(listOf: Playlist.self)
        collectionView.reloadData()
        collectionView.performBatchUpdates({
            collectionView.insertItems(at: [NSIndexPath(item: 1, section: 0) as IndexPath])
            collectionView.reloadItems(at: [NSIndexPath(item: 0, section: 0)as IndexPath])
        }, completion: nil)
    }

    fileprivate func setup(){
        let audiosNib = UINib(nibName: "ListMusicCollectionViewCell", bundle: nil)
        collectionView.register(audiosNib, forCellWithReuseIdentifier: "ListMusicCollectionViewCell")
        let recentNib = UINib(nibName: "RecentCollectionViewCell", bundle: nil)
        collectionView.register(recentNib, forCellWithReuseIdentifier: "RecentCollectionViewCell")
        let clearNib = UINib(nibName: "ClearCollectionViewCell", bundle: nil)
        collectionView.register(clearNib, forCellWithReuseIdentifier: "ClearCollectionViewCell")
        
        
        collectionView.dataSource = self
        collectionView.delegate = self

//        collectionView.isPagingEnabled = false

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout

    }

    @IBAction func onViewBy(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let viewByDialogVC = sb.instantiateViewController(withIdentifier: "ViewByDialogViewController") as! ViewByDialogViewController
        viewByDialogVC.flag = "ViewBy"
        viewByDialogVC.modalPresentationStyle = .overFullScreen
        viewByDialogVC.modalTransitionStyle = .coverVertical
        present(viewByDialogVC, animated: true, completion: nil)
        
        viewByDialogVC.onSubmitViewByButton = { [self] in
            collectionView.reloadData()
        }

    }
    @IBAction func onSortBy(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        switch UserDefaults.standard.integer(forKey: "AudioViewBy") {
        case 0:
            let viewByDialogVC = sb.instantiateViewController(withIdentifier: "ViewByDialogViewController") as! ViewByDialogViewController
            viewByDialogVC.flag = "SortBy"
            viewByDialogVC.modalPresentationStyle = .overFullScreen
            viewByDialogVC.modalTransitionStyle = .coverVertical
            
            present(viewByDialogVC, animated: true, completion: nil)
            viewByDialogVC.onSubmitSortByButton = { [self] in
                collectionView.reloadItems(at: [IndexPath(item: 1, section: 0)])
            }
        case 1:
            let sortByDialogVC = sb.instantiateViewController(withIdentifier: "SortByDialogViewController") as! SortByDialogViewController
            sortByDialogVC.viewBy = .playlist
            sortByDialogVC.modalPresentationStyle = .overFullScreen
            sortByDialogVC.modalTransitionStyle = .coverVertical
            present(sortByDialogVC, animated: true, completion: nil)
            sortByDialogVC.onSubmitSortByButton = { [self] in
                collectionView.reloadItems(at: [IndexPath(item: 1, section: 0)])
            }
        case 2 :
            let sortByDialogVC = sb.instantiateViewController(withIdentifier: "SortByDialogViewController") as! SortByDialogViewController
            sortByDialogVC.viewBy = .album
            sortByDialogVC.modalPresentationStyle = .overFullScreen
            sortByDialogVC.modalTransitionStyle = .coverVertical
            present(sortByDialogVC, animated: true, completion: nil)
            sortByDialogVC.onSubmitSortByButton = { [self] in
                collectionView.reloadItems(at: [IndexPath(item: 1, section: 0)])
            }
        default:
            print("default")
        }

        
    }
    func reloadListMusic(){
        playlists = RealmService.shared.load(listOf: Playlist.self)
        collectionView.reloadItems(at: [IndexPath(item: 1, section: 0)])
    }

    @objc func addNewPlaylist(){
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let newPlaylistVC = sb.instantiateViewController(withIdentifier: "NewPlaylistDialogViewController") as! NewPlaylistDialogViewController
        newPlaylistVC.modalPresentationStyle = .overFullScreen
        newPlaylistVC.modalTransitionStyle = .coverVertical
        present(newPlaylistVC, animated: true, completion: nil)
    }
    func getAlbums(){
        songs = RealmService.shared.load(listOf: Song.self)
        let dictionaries =  Dictionary(grouping: songs, by: { $0.albumName })
        var list = [Album]()
        for (key , value) in dictionaries {
            let album = Album()
            album.albumName = key
            album.songs = value
            list.append(album)
        }
        switch UserDefaults.standard.integer(forKey: "SortByAlbum") {
        case 0:
            list.sort{
                (($0.albumName as AnyObject) as? String) ?? "Unknown" < (($1.albumName as AnyObject) as? String) ?? "Unknown"
            }
            albums = list

        case 1 :
            list.sort{
                (($0.albumName as AnyObject) as? String) ?? "Unknown" > (($1.albumName as AnyObject) as? String) ?? "Unknown"
            }
            albums = list

        default:
            print("default")
        }
    }



}
extension LocalAudioViewController :  UICollectionViewDataSource , UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
        
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if UserDefaults.standard.integer(forKey: "AudioViewBy") == 0 {
            if indexPath.item == 0
            {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentCollectionViewCell", for: indexPath) as! RecentCollectionViewCell
                cell.type = 0
                cell.audioDelegate = self
                return cell
                
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListMusicCollectionViewCell", for: indexPath) as! ListMusicCollectionViewCell
                cell.titleLabel.text = "Your audios"
                cell.vc = self
                cell.delegate = self
                cell.viewBy = .track
                cell.getSongs()
                return cell
            }
        }
        if UserDefaults.standard.integer(forKey: "AudioViewBy") == 1 {
            if indexPath.item == 0
            {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClearCollectionViewCell", for: indexPath) as! ClearCollectionViewCell
                cell.addButton.addTarget(self, action: #selector(addNewPlaylist), for: .touchUpInside)
                return cell
                
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListMusicCollectionViewCell", for: indexPath) as! ListMusicCollectionViewCell
                cell.titleLabel.text = "Your playlists"
                cell.vc = self
                cell.delegate = self
                cell.viewBy = .playlist
                cell.getPlaylists()
                return cell
            }
        }
        else {
            if indexPath.item == 0
            {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClearCollectionViewCell", for: indexPath) as! ClearCollectionViewCell
                return cell
                
            }
            else {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ListMusicCollectionViewCell", for: indexPath) as! ListMusicCollectionViewCell
                cell.titleLabel.text = "Album"
                cell.vc = self
                cell.delegate = self
                cell.viewBy = .album
                cell.getAlbums()
                return cell
            }
            
        }
       
    }
    
}
extension LocalAudioViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UserDefaults.standard.integer(forKey: "AudioViewBy") == 0 {
            if indexPath.item == 0 {
                if recentSongs.count == 0 {
                    return CGSize(width: collectionView.bounds.width, height: 0)
                }
                else {
                    return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height/3)
                }
                
            }
            else {
                return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
            }
        }
        if UserDefaults.standard.integer(forKey: "AudioViewBy") == 1 {
            if indexPath.item == 0 {
                return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height/5)
            }
            else {
                return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
            }
        }
        
        else {
            if indexPath.item == 0 {
                return CGSize(width: collectionView.bounds.width , height: 0)
            }
            else {
                return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
            }
        }
    }

}

extension LocalAudioViewController : AudiosDelegate {

    func onDisplayDetailAudios(position : Int) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        switch UserDefaults.standard.integer(forKey: "AudioViewBy") {
        case 0:
            let vc = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            vc.position = position
            vc.songs = RealmService.shared.sort(by: UserDefaults.standard.integer(forKey: "AudioSortBy"))
            self.present(vc, animated: true, completion: nil)
        case 2:
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let vc = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
            getAlbums()
            vc.songs = albums[position].songs
            vc.position = 0
            self.present(vc, animated: true, completion: nil)
        case 1:
            let playlistVC = sb.instantiateViewController(withIdentifier: "AudioInPlaylistViewController") as! AudioInPlaylistViewController
            switch UserDefaults.standard.integer(forKey: "SortByPlaylist"){
            case 0:
                playlists.sort{
                    (($0.playlistName as AnyObject) as? String) ?? "Unknown" < (($1.playlistName as AnyObject) as? String) ?? "Unknown"
                }
            case 1:
                playlists.sort{
                    (($0.playlistName as AnyObject) as? String) ?? "Unknown" > (($1.playlistName as AnyObject) as? String) ?? "Unknown"
                }
            default:
                print("default")
            }
            playlistVC.playlist = playlists[position]
            self.present(playlistVC, animated: true, completion: nil)
        default:
            print("default")
        }

        
       
    }
    func onDisplayAlertView(indez : Int) {
       
//        alertVC.songs = RealmService.shared.load(listOf: Song.self)
        switch UserDefaults.standard.integer(forKey: "AudioViewBy") {
        case 0:
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let alertVC = sb.instantiateViewController(withIdentifier: "DialogViewController") as! DialogViewController
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .coverVertical
            alertVC.position = indez
            alertVC.playCase = .track
            alertVC.songs = RealmService.shared.sort(by: UserDefaults.standard.integer(forKey: "AudioSortBy"))
            present(alertVC, animated: true, completion: nil)
            
//            alertVC.onReloadCollectionView = { [self] in
//                collectionView.reloadItems(at: [IndexPath(item: 1, section: 0)])
//            }

        case 1:
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let alertVC = sb.instantiateViewController(withIdentifier: "DialogViewController") as! DialogViewController
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .coverVertical
            alertVC.position = indez
            alertVC.playCase = .playlist
            alertVC.playlist = playlists[indez]
            present(alertVC, animated: true, completion: nil)
            
        case 2:
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let alertVC = sb.instantiateViewController(withIdentifier: "DialogOneBtnViewController") as! DialogOneBtnViewController
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .coverVertical
            alertVC.position = indez
            alertVC.songs = RealmService.shared.sort(by: UserDefaults.standard.integer(forKey: "AudioSortBy"))
            present(alertVC, animated: true, completion: nil)
        default:
            print("default")
        }
        

    }
    
}
extension LocalAudioViewController : RecentAudioDelegate {
    func onDisplayRecentAudio(position: Int) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.position = position
        var listSongs = RealmService.shared.get(RecentAudio.self, filter: "name contains 'Recent Audio'")
        var recentSongs = [Song]()
        for i in 0..<listSongs.songs.count{
            recentSongs.append(listSongs.songs[i])
        }
        vc.songs = recentSongs
        self.present(vc, animated: true, completion: nil)
    }
    
}


