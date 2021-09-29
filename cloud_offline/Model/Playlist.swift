//
//  Playlist.swift
//  cloud_offline
//
//  Created by ThanhThanh on 20/08/2021.
//

import Foundation
import RealmSwift
import UIKit
class Playlist : Object {
    var songs = RealmSwift.List < Song > ()
    @objc dynamic var playlistName : String?
}
class PlaylistVideo: Object {
    var videos = RealmSwift.List < Video > ()
    @objc dynamic var playlistName : String?
}
class RecentAudio : Object {
    @objc dynamic var name = "Recent Audio"
    @objc dynamic var count : Int  = 0
    var songs = RealmSwift.List < Song > ()
    
}
class RecentVideo : Object {
    @objc dynamic var name = "Recent Video"
    @objc dynamic var count : Int  = 0
    var videos = RealmSwift.List < Video > ()
}
