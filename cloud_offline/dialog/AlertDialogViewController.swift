//
//  AlertDialogViewController.swift
//  cloud_offline
//
//  Created by ThanhThanh on 21/08/2021.
//

import UIKit
import RealmSwift

class AlertDialogViewController: UIViewController {

    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertLbl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    
    var songs = [Song]()
    var playlist = Playlist()
    var position : Int = 0
    var playlistVideo = PlaylistVideo()
    var type = 0 
    override func viewDidLoad() {
        super.viewDidLoad()

        alertView.layer.cornerRadius = 10
        cancelBtn.setTitleColor(.red, for: .selected)
        submitBtn.setTitleColor(.red, for: .selected)
        alertLbl.adjustsFontSizeToFitWidth = true
        alertLbl.preferredMaxLayoutWidth = alertView.bounds.width
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func submit(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AudioInPlaylistViewController") as! AudioInPlaylistViewController
        if type == 0 {
            RealmService.shared.removeAudio(index: position, playlist: playlist)
            vc.playlist = playlist
            vc.type = 0
        }
        else {
            RealmService.shared.removeVideo(index: position, playlist: playlistVideo)
            vc.playlistVideo = playlistVideo
            vc.type = 1
        }
        present(vc, animated: true, completion: nil)
        
    }
   

}
