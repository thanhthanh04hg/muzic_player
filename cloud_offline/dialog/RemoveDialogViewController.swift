//
//  RemoveDialogViewController.swift
//  cloud_offline
//
//  Created by ThanhThanh on 21/08/2021.
//

import UIKit

class RemoveDialogViewController: UIViewController {

    @IBOutlet weak var dialogView: UIView!
    @IBOutlet weak var removeBtn: UIButton!
    @IBOutlet weak var tapView: UIView!
    
    var newView = UIView()
    var playlist = Playlist()
    var position : Int = 0
    var playlistVideo = PlaylistVideo()
    var type = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapButton))
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func remove(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "AlertDialogViewController") as! AlertDialogViewController
        if type == 0 {
            vc.playlist = playlist
            vc.position = position
            vc.type = 0
        }
        else{
            vc.playlistVideo = playlistVideo
            vc.position = position
            vc.type = 1
        }
        
        present(vc, animated: true, completion: nil)

    }
    @objc func didTapButton(){
        dismiss(animated: true, completion: nil)
    }
    

    
}
