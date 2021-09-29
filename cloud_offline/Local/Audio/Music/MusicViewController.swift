//
//  MusicViewController.swift
//  cloud_offline
//
//  Created by Macbook on 10/06/2021.
//

import UIKit


class MusicViewController: UIViewController {

    @IBOutlet var musicTable: UICollectionView!
    var songs = [Song]()
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "UsualCollectionViewCell", bundle: nil)
        musicTable.register(nib, forCellWithReuseIdentifier: "UsualCollectionViewCell")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: musicTable.bounds.width, height: musicTable.bounds.height/3)
//        configureSongs()
        musicTable.collectionViewLayout = layout
        musicTable.dataSource = self
        musicTable.delegate = self
    }
//    func configureSongs() {
//            songs.append(Song(name: "Attention",
//                              albumName: "123 Other",
//                              artistName: "Charlie Puth",
//                              imageName: "music1",
//                              trackName: "song1"))
//        songs.append(Song(name: "Big Big World",
//                          albumName: "123 Other",
//                          artistName: "Emilia",
//                          imageName: "music2",
//                          trackName: "song2"))
//        songs.append(Song(name: "Everything i need",
//                          albumName: "123 Other",
//                          artistName: "Skylar Grey",
//                          imageName: "music3",
//                          trackName: "song3"))
//        }
//

    


}
extension MusicViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return songs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UsualCollectionViewCell", for: indexPath) as! UsualCollectionViewCell
        cell.image.image = UIImage(named: songs[indexPath.row].imageName ?? "unknown_music")
        cell.label.text = songs[indexPath.row].name
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        
        let detailVc = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailVc.songs = songs
        detailVc.position = indexPath.row
        self.navigationController?.pushViewController(detailVc, animated: true)
    }
}


