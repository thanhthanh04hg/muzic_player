//
//  BackgroundVideo.swift
//  cloud_offline
//
//  Created by ThanhThanh on 22/09/2021.
//

import Foundation
import AVFoundation
import UIKit
class BackgroundVideo: UIView {
  var player: AVPlayer?

    func createBackground(name: String, type: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: type) else { return }

        player = AVPlayer(url: URL(fileURLWithPath: path))
        player?.actionAtItemEnd = AVPlayer.ActionAtItemEnd.none;
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.frame = self.frame
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.layer.insertSublayer(playerLayer, at: 0)
        player?.seek(to: CMTime.zero)
        player?.play()
    }
}
