//
//  RecentCollectionViewCell.swift
//  cloud_offline
//
//  Created by ThanhThanh on 11/08/2021.
//

import UIKit

class RecentCollectionViewCell: UICollectionViewCell{


    @IBOutlet weak var recentCollView: UICollectionView!
    var songs = [Song]()
    var videos = [Video]()
    var viewBy : AudioViewBy = .track
    var recentSongs = RealmService.shared.get(RecentAudio.self, filter: "name contains 'Recent Audio'")
    var recentVideos = RealmService.shared.get(RecentVideo.self, filter: "name contains 'Recent Video'")
    var type = 0 ;
    weak var videoDelegate : VideosDelegate?
    weak var audioDelegate : RecentAudioDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        let nib = UINib(nibName: "DetailRecentCollectionViewCell", bundle: nil)
        recentCollView.register(nib, forCellWithReuseIdentifier: "DetailRecentCollectionViewCell")

        recentCollView.dataSource = self
        recentCollView.delegate = self
        
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        recentCollView.collectionViewLayout = layout
        
    }
    @objc func didTapToPlayAudio(sender : UIButton){
        if let del = self.audioDelegate {
            del.onDisplayRecentAudio(position: sender.tag)
        }
    }
    @objc func didTapToPlayVideo(sender : UIButton){
        if let del = self.videoDelegate {
            del.onDisplayDetailVideo(position: sender.tag)
        }
    }

}
extension RecentCollectionViewCell: UICollectionViewDelegate , UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if type == 0 {
            return recentSongs.songs.count
        }
        else {
            return recentVideos.videos.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if type == 0 {
            if let del = self.audioDelegate {
                del.onDisplayRecentAudio(position: indexPath.item)
            }
        }
        else {
            if let del = self.videoDelegate {
                del.onDisplayDetailVideo(position: indexPath.item)
            }
        }
        
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = recentCollView.dequeueReusableCell(withReuseIdentifier: "DetailRecentCollectionViewCell", for: indexPath) as! DetailRecentCollectionViewCell
        if type == 0 {
            cell.musicImage.roundCorners(cornerRadius: 16)
            cell.musicImage.image = recentSongs.songs[indexPath.item].artwork
            cell.nameLbl.text = recentSongs.songs[indexPath.item].name
            cell.singerLbl.text = recentSongs.songs[indexPath.item].artistName
            cell.playBtn.addTarget(self, action: #selector(didTapToPlayAudio), for: .touchUpInside)
            cell.playBtn.tag = indexPath.item
        }
        else {
            cell.musicImage.roundCorners(cornerRadius: 16)
            cell.musicImage.image = UIImage(named: "unknown_music")
            cell.nameLbl.text = recentVideos.videos[indexPath.item].videoName
            cell.singerLbl.text = ""
            cell.playBtn.addTarget(self, action: #selector(didTapToPlayVideo), for: .touchUpInside)
            cell.playBtn.tag = indexPath.item
        }
        
        return cell
    }
}
extension RecentCollectionViewCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/2, height: collectionView.bounds.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}
protocol VideosDelegate : class {
    func onDisplayDetailVideo(position : Int)
}
protocol RecentAudioDelegate : class {
    func onDisplayRecentAudio(position : Int)
}
