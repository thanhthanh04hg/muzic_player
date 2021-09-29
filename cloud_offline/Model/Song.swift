//
//  Music.swift
//  cloud_offline
//
//  Created by Macbook on 13/07/2021.
//

import Foundation
import UIKit
import RealmSwift

class Song : Object {
    enum MusicType {
        case LOCAL, ONLINE, NONE
    }
    @objc dynamic var name: String?
    @objc dynamic var artistName: String?
    @objc dynamic var imageName: String?
//    @objc dynamic var artwork : UIImageView = UIImageView(image: UIImage(named: "unknown_music"))
    @objc dynamic var trackName: String?
    @objc dynamic var albumName : String?
    @objc dynamic var id : String?
    @objc dynamic var urlString : String?
    @objc dynamic private var imageData: Data? = nil
    dynamic private var _image: UIImage? = nil

    dynamic var artwork: UIImage? {
        set{
            self._image = newValue
            self.imageData = newValue?.pngData() as Data?

        }
        get{
            if let image = self._image {
                return image
            }
            if let data = self.imageData {
                self._image = UIImage(data: data as Data)
                return self._image
            }
            return UIImage(named: "unknown_music")
        }
    }
}
