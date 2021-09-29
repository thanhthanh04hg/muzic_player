//
//  NewPlaylistDialogViewController.swift
//  cloud_offline
//
//  Created by ThanhThanh on 19/08/2021.
//

import UIKit
import RealmSwift
class NewPlaylistDialogViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var playlistText: UITextField!
    var titleStr = "Create new playlist"
    var placeholderStr = ""
    var flag = 0
    var playlist = Playlist()
    var position = 0
    var type = 0
    var playlistVideo = PlaylistVideo()
    override func viewDidLoad() {
        super.viewDidLoad()
        dialogView.layer.cornerRadius = 10
        playlistText.placeholder = "Playlist name"
        playlistText.text = placeholderStr
        titleLbl.text = titleStr
    }

    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submit(_ sender: Any) {
        if playlistText.text == "" {
            alertView()
        }
        else {
            if flag == 0 {
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let vc = sb.instantiateViewController(withIdentifier: "AddNewPlaylistViewController") as! AddNewPlaylistViewController
                vc.playlistName = playlistText.text!
                if type == 0 {
                    vc.type = 0
                }
                else {
                    vc.type = 1
                }
                self.present(vc, animated: true, completion: nil)
                
            }
            else {
                if type == 0 {
                    let realm = try! Realm()
                    let x = RealmService.shared.load(listOf: Playlist.self)
                    try! realm.write{
                        x[position].playlistName = playlistText.text
                    }
                    let sb = UIStoryboard(name: "Main", bundle: nil)
                    let vc = sb.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                    self.present(vc, animated: true, completion: nil)
                }
                else {
                    let realm = try! Realm()
                    let x = RealmService.shared.load(listOf: PlaylistVideo.self)
                    try! realm.write{
                        x[position].playlistName = playlistText.text
                    }
                    let sb = UIStoryboard(name: "Main", bundle: nil)
                    let vc = sb.instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
                    self.present(vc, animated: true, completion: nil)
                }
                

            }
        }
        
        
    }
    fileprivate func alertView(){
        let alert = UIAlertController(title: "Alert", message: "Please write your playlist name", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

}
