//
//  CloudViewController.swift
//  cloud_offline
//
//  Created by Macbook on 14/07/2021.
//

import UIKit
import MobileCoreServices
import AVFoundation
import AVKit
import MediaPlayer

class CloudViewController: UIViewController {
    //MARK: -UI Components
    @IBOutlet weak var fileView: UIView!
    @IBOutlet weak var odView: UIView!
    @IBOutlet weak var iCloudView: UIView!
    @IBOutlet weak var dbView: UIView!
    @IBOutlet weak var onedriveImage: UIImageView!
    @IBOutlet weak var ggdrView: UIView!
    @IBOutlet weak var dropboxImage: UIImageView!
    @IBOutlet weak var iCloudImage: UIImageView!
    //MARK: -Property
    public static var shared = CloudViewController()
    var avMusicPlayer: AVAudioPlayer!
    var mpMediapicker: MPMediaPickerController!
    var mediaItems = [MPMediaItem]()
    let currentIndex = 0
    public var songs = [Song]()
    @IBOutlet weak var ggDriveImage: UIImageView!
    //    var onReloadLocalAudioVC: (() -> Void)?
    let sb = UIStoryboard(name: "Main", bundle: nil)
    private var audioAsset: AVAsset?
    override func viewDidLoad() {
        super.viewDidLoad()
        fileView.layer.cornerRadius = 7
        odView.layer.cornerRadius = 7
        iCloudView.layer.cornerRadius = 7
        dbView.layer.cornerRadius = 7
        ggdrView.layer.cornerRadius = 7
        
        
    }
    
    @IBAction func onDisplayGGDrive(_ sender: Any) {
        let vc = sb.instantiateViewController(withIdentifier: "ComingSoonViewController") as! ComingSoonViewController
        vc.onlineType = .ggdrive
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func onDisplayDropbox(_ sender: Any) {
        let vc = sb.instantiateViewController(withIdentifier: "ComingSoonViewController") as! ComingSoonViewController
        vc.onlineType = .drop_box
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func onDisplayICloud(_ sender: Any) {
        let vc = sb.instantiateViewController(withIdentifier: "ComingSoonViewController") as! ComingSoonViewController
        vc.onlineType = .icloud
        self.present(vc, animated: true, completion: nil)
    }
    @IBAction func onDisplayOnedrive(_ sender: Any) {
        let vc = sb.instantiateViewController(withIdentifier: "ComingSoonViewController") as! ComingSoonViewController
        vc.onlineType = .onedrive
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func importFiles(_ sender: Any) {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.mp3,.mpeg4Audio,.mpeg2Video,.mpeg4Movie], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        present(documentPicker, animated: true, completion: nil)


    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }    
}

extension CloudViewController: UIDocumentPickerDelegate {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {

        guard let selectedFileURL = urls.first else {
            return
        }
        let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let sandboxFileURL = dir.appendingPathComponent(selectedFileURL.lastPathComponent)
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
            print("Already exists! Do nothing")
        }
        else {
            do {
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                
//MARK: - get properties of music

                print("Copied file!")
            }
            catch {
                print("Error: \(error)")
            }
        }
        let asset = AVAsset(url: sandboxFileURL)
//        asset.duration
        let commonMetaData = asset.commonMetadata
        let avAsset = AVURLAsset(url: sandboxFileURL)
        let filename : NSString = avAsset.url.lastPathComponent as NSString
        let song = Song()
        for item in commonMetaData {
            if item.commonKey?.rawValue == "title" {
                song.name = item.stringValue ?? "Unknown"
            }
            if item.commonKey?.rawValue == "artist" {
                song.artistName = item.stringValue ?? "Unknown"
            }
            if item.commonKey?.rawValue == "albumName" {
                song.albumName = item.stringValue ?? "Unknown"
            }
            if item.commonKey?.rawValue == "artwork" {
                if let audioImage = UIImage(data: item.dataValue!) {
                    song.artwork = audioImage
                    print(audioImage)
                }
                
            }

        }

        var str1 : String = ""
        var str2 : String = ""
        str1 = sandboxFileURL.absoluteString.replacingOccurrences(of: sandboxFileURL.absoluteString.split(separator: "/").last!, with: "")
        str2 = String(sandboxFileURL.absoluteString.split(separator: "/").last!)
        let type = str2.split(separator: ".").last
        UserDefaults.standard.set(str1, forKey: "url")
        if type == "mp3" {
            song.urlString = str2
            RealmService.shared.add(song)
            
        }
        else {
            let video = Video()
            print(str2)
            video.urlString = str2
            video.videoName = filename.description
            RealmService.shared.add(video)
        }
            
    }
   


}
//let artworkItems = AVMetadataItem.metadataItems(from: commonMetaData,
//                                                filteredByIdentifier: .commonIdentifierArtwork)
//
//if let artworkItem = artworkItems.first {
//    // Coerce the value to a Data value using its dataValue property
//    if let imageData = artworkItem.dataValue {
//        let image = UIImage(data: imageData)
//
//        // Process the image.
//    } else {
//        // No image data was found.
//    }
//    print(artworkItem)
//}
