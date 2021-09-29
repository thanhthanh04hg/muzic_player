//
//  DialogOneBtnViewController.swift
//  cloud_offline
//
//  Created by ThanhThanh on 26/08/2021.
//

import UIKit

class DialogOneBtnViewController: UIViewController {

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var tapableView: UIView!
    
    var songs = [Song]()
    var albums = [Album]()
    var position = 0 
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapToExit))
        tapableView.addGestureRecognizer(tapGesture)
        
    }
    
    @IBAction func playAll(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        getAlbums()
        vc.songs = albums[position].songs
        vc.position = 0
        self.present(vc, animated: true, completion: nil)
    }
    @objc func didTapToExit(){
        dismiss(animated: true, completion: nil)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
