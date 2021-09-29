//
//  Album.swift
//  cloud_offline
//
//  Created by ThanhThanh on 15/08/2021.
//

import Foundation
import RealmSwift
import UIKit

class Album : Object {
    var songs = [Song]()
    @objc dynamic var albumName : String?
}

