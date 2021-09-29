//
//  ViewController.swift
//  cloud_offline
//
//  Created by Macbook on 10/06/2021.
//

import UIKit
import AVKit
import AVFoundation
import GoogleSignIn
import GoogleAPIClientForREST
import GTMSessionFetcher
import MobileCoreServices
class ViewController: UIViewController {
    let sb = UIStoryboard.init(name: "Main", bundle: nil)
    fileprivate let service = GTLRDriveService()
    var googleUser: GIDGoogleUser?
    private var drive: ATGoogleDrive?
    @IBOutlet var signInView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupGoogleSignIn()
//        drive = ATGoogleDrive(service)
//        self.signInView.addSubview(GIDSignInButton())
    }

    @IBAction func onDisplayMusic(_ sender: Any) {
        
        let musicVC = sb.instantiateViewController(withIdentifier: "MusicViewController") as! MusicViewController
        self.navigationController?.pushViewController(musicVC, animated: true)
    }
    @IBAction func onDisplayVideo(_ sender: Any) {
        let videoVC = sb.instantiateViewController(identifier: "VideoViewController") as! VideoViewController
        self.navigationController?.pushViewController(videoVC, animated: true)
    }
    
    @IBAction func onDownload(_ sender: Any) {
        let ggDriveVC = sb.instantiateViewController(withIdentifier: "FileViewController") as! FileViewController
        self.navigationController?.pushViewController(ggDriveVC, animated: false)
    }
//    private func setupGoogleSignIn() {
//        GIDSignIn.sharedInstance().delegate = self
//        GIDSignIn.sharedInstance().uiDelegate = self
//        GIDSignIn.sharedInstance().scopes = [kGTLRAuthScopeDrive]
//        GIDSignIn.sharedInstance().signInSilently()
//        // Adding the kGTLRAuthScopeDriveFile scope will ask the user to allow full Google Drive access (read and write) to your app during the OAuth flow.
//    }
}

//extension ViewController: GIDSignInDelegate, GIDSignInUIDelegate {
//    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
//        // A nil error indicates a successful login
//        if error == nil {
//            // Include authorization headers/values with each Drive API request.
//            self.service.authorizer = user.authentication.fetcherAuthorizer()
//            self.googleUser = user
//        } else {
//            self.service.authorizer = nil
//            self.googleUser = nil
//        }
//
//    }
//
//
//}
extension UIView {
   func roundCorners(cornerRadius: Double) {
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.clipsToBounds = true
        
   }
}
