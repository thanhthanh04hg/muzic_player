//
//  LocalVideoViewController.swift
//  cloud_offline
//
//  Created by ThanhThanh on 10/08/2021.
//

import UIKit
import AVKit
import AVFoundation
import MediaPlayer

class LocalVideoViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var videos : [Video] = RealmService.shared.load(listOf: Video.self)
    var viewBy : VideoViewBy = .video
    var playlists = RealmService.shared.load(listOf: PlaylistVideo.self)
    let sb = UIStoryboard(name: "Main", bundle: nil)
    let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    var recentVideos = RealmService.shared.get(RecentVideo.self, filter: "name contains 'Recent Video'")
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        UserDefaults.standard.set(dir?.description, forKey: "url")


    }
    override func viewDidAppear(_ animated: Bool) {
        reloadVideo()
    }
    override func viewDidDisappear(_ animated: Bool) {
        
//        AppUtility.lockOrientation(.all)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AppUtility.lockOrientation(.portrait,andRotateTo: .portrait)
        videos = RealmService.shared.sortVideos(by: UserDefaults.standard.integer(forKey: "VideoSortBy"))
        playlists = RealmService.shared.load(listOf: PlaylistVideo.self)
        reloadVideo()
        collectionView.reloadData()
        collectionView.reloadSections(IndexSet(integer: 0))
    }
    fileprivate func setup(){
        
        let audiosNib = UINib(nibName: "UsualCollectionViewCell", bundle: nil)
        collectionView.register(audiosNib, forCellWithReuseIdentifier: "UsualCollectionViewCell")
        let recentNib = UINib(nibName: "RecentCollectionViewCell", bundle: nil)
        collectionView.register(recentNib, forCellWithReuseIdentifier: "RecentCollectionViewCell")
        let titleNib = UINib(nibName: "TitleCollectionViewCell", bundle: nil)
        collectionView.register(titleNib, forCellWithReuseIdentifier: "TitleCollectionViewCell")
        let clearNib = UINib(nibName: "ClearCollectionViewCell", bundle: nil)
        collectionView.register(clearNib, forCellWithReuseIdentifier: "ClearCollectionViewCell")
        

        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
    }
    fileprivate func reloadVideo(){
        collectionView.performBatchUpdates({
            collectionView.reloadSections(IndexSet(integer: 2))
        }, completion: nil)
    }
    @IBAction func sort(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        switch UserDefaults.standard.integer(forKey: "VideoViewBy") {
        case 0:
            let viewByDialogVC = sb.instantiateViewController(withIdentifier: "ViewByDialogViewController") as! ViewByDialogViewController
            viewByDialogVC.flag = "SortBy"
            viewByDialogVC.type = 1

            viewByDialogVC.modalPresentationStyle = .overFullScreen
            viewByDialogVC.modalTransitionStyle = .coverVertical
            present(viewByDialogVC, animated: true, completion: nil)
            
            viewByDialogVC.onSubmitSortByButton = { [self] in
                videos = RealmService.shared.sortVideos(by: UserDefaults.standard.integer(forKey: "VideoSortBy"))

                collectionView.performBatchUpdates({
                    
                    collectionView.reloadSections(IndexSet(integer: 2))

                }, completion: nil)
                
            }
        case 1:
            print("playlist")

        default:
            print("default")
        }
        
    }
    
    @IBAction func viewBy(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let viewByDialogVC = sb.instantiateViewController(withIdentifier: "ViewByDialogViewController") as! ViewByDialogViewController
        viewByDialogVC.flag = "ViewBy"
        viewByDialogVC.type = 1
        viewByDialogVC.modalPresentationStyle = .overFullScreen
        viewByDialogVC.modalTransitionStyle = .coverVertical
        
        present(viewByDialogVC, animated: true, completion: nil)
        
        viewByDialogVC.onSubmitViewByButton = { [self] in
            collectionView.reloadData()
        }
    }
    @objc func didTapMore(sender : UIButton){
        switch UserDefaults.standard.integer(forKey: "VideoViewBy"){
        case 0 :
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let alertVC = sb.instantiateViewController(withIdentifier: "DialogViewController") as! DialogViewController
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .coverVertical
            alertVC.position = sender.tag
            alertVC.playCase = .track
            alertVC.type = 1
//            alertVC.playlistVideo = playlists[sender.tag]
            alertVC.videos = RealmService.shared.sortVideos(by: UserDefaults.standard.integer(forKey: "VideoSortBy"))
            present(alertVC, animated: true, completion: nil)
        case 1 :
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let alertVC = sb.instantiateViewController(withIdentifier: "DialogViewController") as! DialogViewController
            alertVC.modalPresentationStyle = .overFullScreen
            alertVC.modalTransitionStyle = .coverVertical
            alertVC.position = sender.tag
            alertVC.playCase = .playlist
            alertVC.playlistVideo = playlists[sender.tag]
            alertVC.type = 1
            alertVC.videos = RealmService.shared.sortVideos(by: UserDefaults.standard.integer(forKey: "VideoSortBy"))
            present(alertVC, animated: true, completion: nil)
            
        default:
            print("default")
        }
        
    }
    @objc func addNewPlaylist(sender : UIButton){
        let newPlaylistVC = sb.instantiateViewController(withIdentifier: "NewPlaylistDialogViewController") as! NewPlaylistDialogViewController
        newPlaylistVC.type = 1
        newPlaylistVC.modalPresentationStyle = .overFullScreen
        newPlaylistVC.modalTransitionStyle = .coverVertical
        
        present(newPlaylistVC, animated: true, completion: nil)
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
extension LocalVideoViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 || section == 1{
            return 1
        }
        else {
            switch UserDefaults.standard.integer(forKey: "VideoViewBy"){
            case 0 :
                return videos.count
            case 1 :
                return playlists.count
            default:
                return 0
            }
            
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if UserDefaults.standard.integer(forKey: "VideoViewBy") == 0 {
            switch indexPath.section {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentCollectionViewCell", for: indexPath) as! RecentCollectionViewCell
                cell.videoDelegate = self
                cell.type = 1
                return cell
            case 1 :
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionViewCell", for: indexPath) as! TitleCollectionViewCell
                cell.titleCellLbl.text = "Your video"
                return cell
            case 2 :
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UsualCollectionViewCell", for: indexPath) as! UsualCollectionViewCell
                cell.label.text = videos[indexPath.item].videoName
                let str = UserDefaults.standard.string(forKey: "url")! + videos[indexPath.item].urlString!
                let asset = AVAsset(url: URL(string: str)!)
                let duration = asset.duration
                let durationTime = CMTimeGetSeconds(duration)
                cell.artistLbl.text = floatToString(x: NSInteger(durationTime))
                cell.button.addTarget(self, action: #selector(didTapMore), for: .touchUpInside)
                cell.button.tag = indexPath.item
                return cell
            default:
                print("default")
            }
        }
        else{
            switch indexPath.section {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClearCollectionViewCell", for: indexPath) as! ClearCollectionViewCell
                cell.addButton.addTarget(self, action: #selector(addNewPlaylist), for: .touchUpInside)
                cell.addButton.tag = indexPath.item
                return cell

            case 1 :
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionViewCell", for: indexPath) as! TitleCollectionViewCell
                cell.titleCellLbl.text = "Your playlist"
                return cell

            case 2 :
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UsualCollectionViewCell", for: indexPath) as! UsualCollectionViewCell
                cell.label.text = playlists[indexPath.item].playlistName
                if playlists[indexPath.item].videos.count < 2 {
                    cell.artistLbl.text = (String)(playlists[indexPath.item].videos.count) + " video"
                }
                else {
                    cell.artistLbl.text = (String)(playlists[indexPath.item].videos.count) + " videos"
                }
                cell.button.addTarget(self, action: #selector(didTapMore), for: .touchUpInside)
                cell.button.tag = indexPath.item
                return cell
            default:
                print("default")
            }
        }
        return UICollectionViewCell()

    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch UserDefaults.standard.integer(forKey: "VideoViewBy"){
        case 0:
            let vc = sb.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
            vc.videos = RealmService.shared.sortVideos(by: UserDefaults.standard.integer(forKey: "VideoSortBy"))
            vc.position = indexPath.item
//            let str = UserDefaults.standard.string(forKey: "url")! + videos[indexPath.item].urlString!
//            let videoPathURL = URL(string: str)
//            let player = AVPlayer(url: videoPathURL! as URL)
//            let vc = AVPlayerViewController()
//            vc.player = player
//            present(vc, animated: true) {
//                vc.player?.play()
//            }
            self.present(vc, animated: true, completion: nil)
        case 1:
            let vc = sb.instantiateViewController(withIdentifier: "AudioInPlaylistViewController") as! AudioInPlaylistViewController
//            vc.videos = RealmService.shared.sortVideos(by: UserDefaults.standard.integer(forKey: "VideoSortBy"))
            vc.playlistVideo = playlists[indexPath.item]
            vc.type = 1
            vc.position = indexPath.item
            self.present(vc, animated: true, completion: nil)
        default:
            print("default")
        }        
        
    }
}
extension LocalVideoViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UserDefaults.standard.integer(forKey: "VideoViewBy") == 0{
            if indexPath.section == 0 {
                if recentVideos.count == 0 {
                    return CGSize(width: collectionView.bounds.width, height: 0)
                }
                else {
                    return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height/3)
                }
                
            }
            else {
                return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height/6)
            }
        }
        else {
            if indexPath.section == 0 {
                return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height/6)
            }
            else {
                return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height/6)
            }
        }
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 2{
            return UIEdgeInsets(top: 0, left: 10, bottom: 150, right: 10)
        }
        else {
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        
    }

}
extension LocalVideoViewController : VideosDelegate{
    func onDisplayDetailVideo(position: Int) {
        let vc = sb.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
        vc.position = position
        let listVideo = RealmService.shared.get(RecentVideo.self, filter: "name contains 'Recent Video'")
        var recentVideos = [Video]()
        for i in 0..<listVideo.videos.count{
            recentVideos.append(listVideo.videos[i])
        }
        vc.videos = recentVideos
        self.present(vc, animated: true, completion: nil)
    }
    
    
}

//func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//    if UserDefaults.standard.integer(forKey: "VideoViewBy") == 0 {
//        if indexPath.item == 0 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecentCollectionViewCell", for: indexPath) as! RecentCollectionViewCell
//            return cell
//        }
//        else if indexPath.item ==  1 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionViewCell", for: indexPath) as! TitleCollectionViewCell
//            cell.titleCellLbl.text = "Your video"
//            return cell
//        }
//        else {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UsualCollectionViewCell", for: indexPath) as! UsualCollectionViewCell
//            cell.label.text = videos[indexPath.item].videoName
//            cell.artistLbl.text = ""
//            return cell
//
//        }
//
//
//    }
//    else{
//        if indexPath.item == 0 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ClearCollectionViewCell", for: indexPath) as! ClearCollectionViewCell
////                cell.addButton.addTarget(self, action: #selector(addNewPlaylist), for: .touchUpInside)
//            return cell
//        }
//        else if indexPath.item ==  1 {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionViewCell", for: indexPath) as! TitleCollectionViewCell
//            cell.titleCellLbl.text = "Your playlist"
//            return cell
//        }
//        else {
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UsualCollectionViewCell", for: indexPath) as! UsualCollectionViewCell
//            cell.label.text = videos[indexPath.item].videoName
//            cell.artistLbl.text = ""
//            return cell
//
//        }
//    }
//
//}
