//
//  File.swift
//  cloud_offline
//
//  Created by ThanhThanh on 13/08/2021.
//

import Foundation
enum AudioSortBy {
    case az
    case za
    case lastest
    case oldest
}
enum AudioViewBy{
    case track
    case playlist
    case album
}
enum VideoViewBy{
    case video
    case playlist
}
enum SearchBy {
    case name
    case album
    case artist
    case all 
}
enum OnlineType{
    case ggdrive
    case drop_box
    case icloud
    case onedrive
}
