//
//  ListMusicCollectionViewCell.swift
//  cloud_offline
//
//  Created by Macbook on 16/07/2021.
//

import UIKit
import RealmSwift
class ListMusicCollectionViewCell: UICollectionViewCell {
    //MARK: UI Component
    @IBOutlet var audioCollectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: Property
    var viewBy : AudioViewBy = .track
    
    var songs = [Song]()
    var albums = [Album]()
    var playlists = [Playlist]()
    var position : Int = 0
    weak var delegate : AudiosDelegate?
    var vc = LocalAudioViewController()
        
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: "UsualCollectionViewCell", bundle: nil)
        audioCollectionView.register(nib, forCellWithReuseIdentifier: "UsualCollectionViewCell")
        
        audioCollectionView.delegate = self
        audioCollectionView.dataSource = self
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        audioCollectionView.collectionViewLayout = layout
        audioCollectionView.isScrollEnabled = true 
//        getSongs()
//        getAlbums()
                
    }
    func getSongs(){
        songs = RealmService.shared.sort(by: UserDefaults.standard.integer(forKey: "AudioSortBy"))
        DispatchQueue.main.async() {
            self.audioCollectionView.reloadData()
        }
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
        case 1 :
            list.sort{
                (($0.albumName as AnyObject) as? String) ?? "Unknown" > (($1.albumName as AnyObject) as? String) ?? "Unknown"
            }
        default:
            print("default")
        }
        albums = list
        DispatchQueue.main.async() {
            self.audioCollectionView.reloadData()
        }
    }
    func getPlaylists(){
        playlists = RealmService.shared.load(listOf: Playlist.self)
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
        DispatchQueue.main.async() {
            self.audioCollectionView.reloadData()
        }
        
    }

    //MARK: -Action

}
extension ListMusicCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch viewBy {
        case .track:
            return songs.count
            
        case .playlist:
            return playlists.count
            
        case .album:
            return albums.count
        }

    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UsualCollectionViewCell", for: indexPath) as! UsualCollectionViewCell
        switch viewBy {
        case .track:
            cell.label.text = songs[indexPath.item].name ?? "Unknown"
            cell.artistLbl.text = songs[indexPath.item].artistName ?? "Unknown"
            cell.image.image = songs[indexPath.item].artwork ?? UIImage(named: "unknown_music")
        case .playlist:
            cell.label.text = playlists[indexPath.item].playlistName
            cell.artistLbl.text = (String)(playlists[indexPath.item].songs.count)
            cell.image.image = playlists[indexPath.item].songs[0].artwork ?? UIImage(named: "unknown_music")
            
        case .album:
            cell.label.text = albums[indexPath.item].albumName
            cell.artistLbl.text = albums[indexPath.item].songs[0].artistName
            cell.image.image = albums[indexPath.item].songs[0].artwork ?? UIImage(named: "unknown_music")
        }
        
        cell.button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        cell.button.tag = indexPath.item
       
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        position = indexPath.item
        if let del = self.delegate {
            del.onDisplayDetailAudios(position: position)
        }
    }
    @objc func buttonAction(sender: UIButton!) {
        if let del = self.delegate {
            del.onDisplayAlertView(indez: sender.tag)
        }
    }

    
    
}
extension ListMusicCollectionViewCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height/6)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 150, right: 10)
    }
}


protocol AudiosDelegate : class {
    func onDisplayDetailAudios(position : Int)
    func onDisplayAlertView(indez : Int)
}

//NhacCuaTui.Com
