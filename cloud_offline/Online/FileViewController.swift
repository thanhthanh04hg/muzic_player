//
//  FileViewController.swift
//  cloud_offline
//
//  Created by Macbook on 09/07/2021.
//

import UIKit

import GoogleSignIn
import GoogleAPIClientForREST
import GTMSessionFetcher

class FileViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    private var drive: ATGoogleDrive?
    fileprivate let service = GTLRDriveService()
    var list = [GTLRDrive_File]()
    var listAudio = [GTLRDrive_File]()
    var googleUser: GIDGoogleUser?
    var songs = [Song]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "UsualCollectionViewCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: "UsualCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        collectionView.collectionViewLayout = layout
        getFile()
        
        
    }

    func getFile(){
        drive?.listDrive { (files, error) in
            guard let fileList = files else {
                print("Error listing files: \(error?.localizedDescription)")
                return
            }
            self.list = fileList.files!
            for i in 0...self.list.count-1  {
                if(self.list[i].mimeType == "video/mp4" || self.list[i].mimeType == "video/flv" || self.list[i].mimeType == "audio/mpeg"){
                    self.listAudio.append(self.list[i])
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.collectionView.reloadData()
            }
        }
    }
}
extension FileViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listAudio.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UsualCollectionViewCell", for: indexPath) as! UsualCollectionViewCell
        cell.label.text = listAudio[indexPath.item].name
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        drive?.downloadAndSaveAudioFile(listAudio[indexPath.item].identifier!){_ in
            print("download")
        }
//        drive?.download(listAudio[indexPath.item].identifier!){_,_ in
//            print("Download")
//            
//        }
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let songVC = sb.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        songVC.listAudio = self.listAudio
        songVC.position = indexPath.item
        self.navigationController?.pushViewController(songVC, animated: false)
    }
    
    
}

extension FileViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.width, height: collectionView.frame.height/3)
        
    }
}
