//
//  ComingSoonViewController.swift
//  cloud_offline
//
//  Created by ThanhThanh on 25/09/2021.
//

import UIKit

class ComingSoonViewController: UIViewController {

    @IBOutlet weak var mainLbl: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    var onlineType : OnlineType = .ggdrive
    override func viewDidLoad() {
        super.viewDidLoad()
        setupOnlineType()
        
    }
    fileprivate func setupOnlineType(){
        switch onlineType {
        case .ggdrive:
            mainLbl.text = "Google Drive"
            logoImage.image = UIImage(named: "logos_google-drive")
        case .drop_box:
            mainLbl.text = "Dropbox"
            logoImage.image = UIImage(named: "logos_dropbox")
        case .icloud:
            mainLbl.text = "iCloud"
            logoImage.image = UIImage(named: "1200px-ICloud_logo 1")
        case .onedrive:
            mainLbl.text = "Onedrive"
            logoImage.image = UIImage(named: "toppng 1")
        }
    }
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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

