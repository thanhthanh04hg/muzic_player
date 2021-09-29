//
//  AVInSearchViewController.swift
//  cloud_offline
//
//  Created by ThanhThanh on 16/09/2021.
//

import UIKit

class AVInSearchViewController: UIViewController {
    //MARK: - UI Components
    @IBOutlet weak var collectionView: UICollectionView!
    //MARK: - Properties
    var type = 0
//    var audios = [Song]()
//    var videos = [Video]()
    var audios = RealmService.shared.load(listOf: Song.self)
    var videos = RealmService.shared.load(listOf: Video.self)
    var videoByAll = [Video]()
    var audioByAll = [Song]()
    var videoByName = [Video]()
    var audioByName = [Song]()
    var videoByAlbum = [Video]()
    var audioByAlbum = [Song]()
    var videoByArtist = [Video]()
    var audioByArtist = [Song]()
    var str : String = ""
    var searchBy : SearchBy = .all
    let sb = UIStoryboard(name: "Main", bundle: nil)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let usualNib = UINib(nibName: "UsualCollectionViewCell", bundle: nil)
        collectionView.register(usualNib, forCellWithReuseIdentifier: "UsualCollectionViewCell")
        let noResultNib = UINib(nibName: "NoResultCollectionViewCell", bundle: nil)
        collectionView.register(noResultNib, forCellWithReuseIdentifier: "NoResultCollectionViewCell")
        let titleNib = UINib(nibName: "TitleCollectionViewCell", bundle: nil)
        collectionView.register(titleNib, forCellWithReuseIdentifier: "TitleCollectionViewCell")
        let searchNib = UINib(nibName: "SearchCollectionViewCell", bundle: nil)
        collectionView.register(searchNib, forCellWithReuseIdentifier: "SearchCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        setupLayout()
        setupArrayAV()
        
    }
    func setupArrayAV(){
        audioByName = audios
        videoByName = videos
        audioByAll = audios
        videoByAll = videos
        audioByAlbum = audios
        audioByArtist = audios
    }
    override func viewWillAppear(_ animated: Bool) {
        collectionView.reloadData()
    }
    fileprivate func setupLayout(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView.collectionViewLayout = layout
    }
    func reload(){
        collectionView.reloadData()
        print("reload")

    }    

}
extension AVInSearchViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            if videos.count == 0 {
                return 2
            }
            else {
                switch searchBy {
                case .all:
                    if videoByAll.count == 0 {
                        return 2
                    }
                    return videoByAll.count + 1
                case .name:
                    if videoByName.count == 0 {
                        return 2
                    }
                    return videoByName.count + 1
                case .album:
                    return 2
                case .artist:
                    return 2
                }
            }
        }
        else {
            if audios.count == 0 {
                return 2
            }

            else {
                switch searchBy {
                case .all:
                    if audioByAll.count == 0 {
                        return 2
                    }
                    return audioByAll.count + 1
                case .name:
                    if audioByName.count == 0 {
                        return 2
                    }
                    return audioByName.count + 1
                case .album:
                    if audioByAlbum.count == 0 {
                        return 2
                    }
                    return audioByAlbum.count + 1
                case .artist:
                    if audioByArtist.count == 0 {
                        return 2
                    }
                    return audioByArtist.count + 1
                }
            }
           
        }
    }
    fileprivate func onDisplayAudio(position : Int){
        
        let vc = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.position = position
        vc.songs = RealmService.shared.sort(by: UserDefaults.standard.integer(forKey: "AudioSortBy"))
        self.present(vc, animated: true, completion: nil)
        
    }
    fileprivate func onDisplayVideo(position : Int){
        let vc = sb.instantiateViewController(withIdentifier: "VideoViewController") as! VideoViewController
        vc.videos = RealmService.shared.sortVideos(by: UserDefaults.standard.integer(forKey: "VideoSortBy"))
        vc.position = position
        self.present(vc, animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.item != 0 {
                switch searchBy {
                case .name:
                    if videoByName.count != 0 {
                        onDisplayVideo(position: indexPath.item)
                    }
                    
                   
                case .all:
                    if videoByAll.count != 0 {
                        onDisplayVideo(position: indexPath.item)
                    }
                    
                default:
                    print("default")
                    
                }
            }
        }
        if indexPath.section == 1 {
            if indexPath.item != 0 {
                switch searchBy {
                case .name:
                    if audioByName.count != 0 {
                        onDisplayAudio(position: indexPath.item)
                    }

                case .all:
                    if audioByAll.count != 0 {
                        onDisplayAudio(position: indexPath.item)
                    }
                    
                case .album:
                    if audioByAlbum.count != 0 {
                        onDisplayAudio(position: indexPath.item)
                    }
                case .artist:
                    if audioByArtist.count != 0{
                        onDisplayAudio(position: indexPath.item)
                    }
                    
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let titleCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCollectionViewCell", for: indexPath) as! TitleCollectionViewCell
        let searchCell = collectionView.dequeueReusableCell(withReuseIdentifier: "SearchCollectionViewCell", for: indexPath) as! SearchCollectionViewCell
        let noResultCell = collectionView.dequeueReusableCell(withReuseIdentifier: "NoResultCollectionViewCell", for: indexPath) as! NoResultCollectionViewCell
        
        if indexPath.section == 0 {

            if indexPath.item == 0 {
                titleCell.titleCellLbl.text = "In Videos"
                return titleCell
            }
            else {
                if videos.count == 0 {
                    noResultCell.informLbl.text = "No Video Result"
                    return noResultCell
                }
                else {
                    switch searchBy {
                    case .name:
                        if videoByName.count == 0 {
                            noResultCell.informLbl.text = "No Video Result"
                            return noResultCell
                        }
                        else {
                            searchCell.nameLbl.text = videoByName[indexPath.item-1].videoName
                            searchCell.artistLbl.text = ""
                            searchCell.mainImage.image = UIImage(named: "unknown_music")
                            return searchCell
                        }
                       
                    case .all:
                        if videoByAll.count == 0 {
                            noResultCell.informLbl.text = "No Video Result"
                            return noResultCell
                        }
                        else {
                            searchCell.nameLbl.text = videoByAll[indexPath.item-1].videoName
                            searchCell.artistLbl.text = ""
                            searchCell.mainImage.image = UIImage(named: "unknown_music")
                            return searchCell
                        }
                        
                    case .album:
                        noResultCell.informLbl.text = "No Video Result"
                        return noResultCell
                    case .artist:
                        noResultCell.informLbl.text = "No Video Result"
                        return noResultCell
                    }
                    
                    
                }

            }
               
            
        }
        else {
            if indexPath.item == 0 {
                titleCell.titleCellLbl.text = "In Audios"
                return titleCell
            }
            else {
                if audios.count == 0{
                    noResultCell.informLbl.text = "No Audio Result"
                    return noResultCell
                }
                else {
                    switch searchBy {
                    case .name:
                        if audioByName.count == 0 {
                            noResultCell.informLbl.text = "No Audio Result"
                            return noResultCell
                        }
                        else {
                            searchCell.nameLbl.text = audioByName[indexPath.item-1].name
                            searchCell.artistLbl.text = audioByName[indexPath.item-1].artistName
                            searchCell.mainImage.image = audioByName[indexPath.item-1].artwork
                        }
                        
                    case .all:
                        if audioByAll.count == 0 {
                            noResultCell.informLbl.text = "No Audio Result"
                            return noResultCell
                        }
                        else {
                            searchCell.nameLbl.text = audioByAll[indexPath.item-1].name
                            searchCell.artistLbl.text = audioByAll[indexPath.item-1].artistName
                            searchCell.mainImage.image = audioByAll[indexPath.item-1].artwork
                        }
                    case .album:
                        if audioByAlbum.count == 0 {
                            noResultCell.informLbl.text = "No Audio Result"
                            return noResultCell
                        }
                        else {
                            searchCell.nameLbl.text = audioByAlbum[indexPath.item-1].name
                            searchCell.artistLbl.text = audioByAlbum[indexPath.item-1].artistName
                            searchCell.mainImage.image = audioByAlbum[indexPath.item-1].artwork
                        }

                    case .artist:
                        if audioByArtist.count == 0 {
                            noResultCell.informLbl.text = "No Audio Result"
                            return noResultCell
                        }
                        else {
                            searchCell.nameLbl.text = audioByArtist[indexPath.item-1].name
                            searchCell.artistLbl.text = audioByArtist[indexPath.item-1].artistName
                            searchCell.mainImage.image = audioByArtist[indexPath.item-1].artwork
                        }
                    }
                    
                    return searchCell
                }
                
            }
        }
    }
        
}
extension AVInSearchViewController : UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height/10)
        }
        else {
            return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height/6)
        }
       
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 10, bottom: 10, right: 10)
    }
}
