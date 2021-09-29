//
//  SearchViewController.swift
//  cloud_offline
//
//  Created by ThanhThanh on 16/09/2021.
//

import UIKit
import Tabman
import Pageboy
class SearchViewController: TabmanViewController , TMBarDataSource {
//MARK: -UI Components
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tabView: UIView!
    //MARK: -Properties
    static let allCateVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AVInSearchViewController") as! AVInSearchViewController
    static let nameVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AVInSearchViewController") as! AVInSearchViewController
    static let albumVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AVInSearchViewController") as! AVInSearchViewController
    static let artistVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AVInSearchViewController") as! AVInSearchViewController
    private var viewControllers = [allCateVC,nameVC,albumVC,artistVC]
    var filterVideos = [Video]()
    var filterAudios = [Song]()
    var filterVideoData = [Video]()
    var filterAudioData = [Song]()
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
    var searchBy : SearchBy = .all
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.searchBar.delegate = self
        createBar()
        setupAVForCurrentIndex(video: videos, audio: audios)
        filterAudios = audios
        filterVideos = videos
        setupAVBy()
    }
    fileprivate func setupAVBy(){
        audioByName = audios
        videoByName = videos
        audioByAll = audios
        videoByAll = videos
        audioByAlbum = audios
        videoByAlbum = videos
        audioByArtist = audios
        videoByArtist = videos
    }
    func setupAVForCurrentIndex(video : [Video] , audio : [Song]){
        viewControllers[currentIndex!].audioByName = audio
        viewControllers[currentIndex!].videoByName = video
        viewControllers[currentIndex!].audioByAll = audio
        viewControllers[currentIndex!].videoByAll = video
        viewControllers[currentIndex!].audioByAlbum = audio
        viewControllers[currentIndex!].videoByAlbum = video
        viewControllers[currentIndex!].audioByArtist = audio
        viewControllers[currentIndex!].videoByArtist = video
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    fileprivate func createBar(){
        let bar = TMBar.ButtonBar()
        bar.largeContentTitle = "Local"
        bar.layout.transitionStyle = .snap // Customize
        // Add to view
        bar.buttons.customize { (button) in
            button.tintColor = .gray
            button.selectedTintColor = .orange
            button.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 30)
        }
        bar.backgroundColor = .white
        bar.indicator.tintColor = .orange
        bar.backgroundView.style = .blur(style: .light)
        self.addBar(bar, dataSource: self, at: .custom(view: tabView, layout: nil))
        
    }
}
extension SearchViewController : PageboyViewControllerDataSource {
    func numberOfViewControllers(in pageboyViewController: PageboyViewController) -> Int {
            return viewControllers.count
        }

    func viewController(for pageboyViewController: PageboyViewController,
                        at index: PageboyViewController.PageIndex) -> UIViewController? {
        viewControllers[index].type = index
        viewControllers[index].audioByName = audioByName
        viewControllers[index].videoByName = videoByName
        viewControllers[index].audioByAll = audioByAll
        viewControllers[index].videoByAll = videoByAll
        viewControllers[index].audioByAlbum = audioByAlbum
        viewControllers[index].audioByArtist = audioByArtist
        switch index {
        case 0:
            viewControllers[index].searchBy = .all
        case 1:
            viewControllers[index].searchBy = .name
        case 2 :
            viewControllers[index].searchBy = .album
        case 3 :
            viewControllers[index].searchBy = .artist
        default:
            print("default")
        }
        return self.viewControllers[index]
    }

    func defaultPage(for pageboyViewController: PageboyViewController) -> PageboyViewController.Page? {
        return nil
    }

    func barItem(for bar: TMBar, at index: Int) -> TMBarItemable {
        var title = ""
        switch index {
        case 0:
            title = "All Categories"
        case 1:
            title = "Name"
        case 2:
            title = "Album"
        case 3 :
            title = "Artist"
        default:
            print("default")
        }
        
        return TMBarItem(title: title)
    }
}
extension SearchViewController : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        filterAudios = []
//        filterVideos = []
//        defineSearchBy()
        audioByAll = []
        videoByAll = []
        videoByName = []
        audioByName = []
        audioByAlbum = []
        audioByArtist = []
        if searchText == ""{
            for i in 0..<audios.count{
                audioByAll.append(audios[i])
                audioByName.append(audios[i])
                audioByArtist.append(audios[i])
                audioByAlbum.append(audios[i])

            }
            for i in 0..<videos.count{
                videoByAll.append(videos[i])
                videoByName.append(videos[i])
                
//                filterVideos.append(videos[i])
            }
//            setupAVForCurrentIndex(video: filterVideos, audio: filterAudios )
        }
        
        else{
            for song in audios {
                if song.name!.lowercased().contains(searchText.lowercased()){
                    audioByName.append(song)
                }
                if song.name!.lowercased().contains(searchText.lowercased()) || song.artistName!.lowercased().contains(searchText.lowercased()) || song.albumName!.lowercased().contains(searchText.lowercased()){
                    audioByAll.append(song)
                }
                if song.albumName!.lowercased().contains(searchText.lowercased()){
                    audioByAlbum.append(song)
                }
                if song.artistName!.lowercased().contains(searchText.lowercased()){
                    audioByArtist.append(song)
                }
            }
            for video in videos{
                if video.videoName!.lowercased().contains(searchText.lowercased()){
                    videoByName.append(video)
                }
                if video.videoName!.lowercased().contains(searchText.lowercased()){
                    videoByAll.append(video)
                }
            }
            print(audioByAlbum.count)
            print(audioByAll.count)
//            switch searchBy {
//            case .name:
//                for song in audios {
//                    if song.name!.lowercased().contains(searchText.lowercased()){
////                        filterAudios.append(song)
//                        audioByName.append(song)
//                    }
//                }
//                for video in videos{
//                    if video.videoName!.lowercased().contains(searchText.lowercased()){
//                        videoByName.append(video)
//                    }
//                }
//
//            case .all:
//
//                for song in audios {
//                    if song.name!.lowercased().contains(searchText.lowercased()) || song.artistName!.lowercased().contains(searchText.lowercased()) || song.albumName!.lowercased().contains(searchText.lowercased()){
////                        filterAudios.append(song)
//                        audioByAll.append(song)
//                    }
//                }
//                for video in videos{
//                    if video.videoName!.lowercased().contains(searchText.lowercased()){
//                        videoByAll.append(video)
//                    }
//                }
//
//            case .album:
//                for song in audios {
//                    if song.albumName!.lowercased().contains(searchText.lowercased()){
//                        audioByAlbum.append(song)
//                    }
//                }
//
//            case .artist:
//                for song in audios {
//                    if song.artistName!.lowercased().contains(searchText.lowercased()){
//                        audioByArtist.append(song)
//                    }
//                }
//
//
//            }
            
        }
        viewControllers[currentIndex!].audioByName = audioByName
        viewControllers[currentIndex!].videoByName = videoByName
        viewControllers[currentIndex!].audioByAll = audioByName
        viewControllers[currentIndex!].videoByAll = videoByAll
        viewControllers[currentIndex!].audioByAlbum = audioByAlbum
        viewControllers[currentIndex!].audioByArtist = audioByArtist
        viewControllers[currentIndex!].audios = filterAudios
        viewControllers[currentIndex!].videos = filterVideos
        viewControllers[currentIndex!].reload()

    }
    func defineSearchBy(){
        switch currentIndex! {
        case 0:
            searchBy = .all
            print("all")
        case 1 :
            searchBy = .name
            print("name")
        case 2 :
            searchBy = .album
            print("album")
        case 3:
            searchBy = .artist
            print("artist")
        default:
            print("default")
        }
    }
}
