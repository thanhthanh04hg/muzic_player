//
//  DetailRecentCollectionViewCell.swift
//  cloud_offline
//
//  Created by ThanhThanh on 11/08/2021.
//

import UIKit

class DetailRecentCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var musicImage: UIImageView!
    @IBOutlet weak var singerLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var playBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
//        nameLbl.adjustsFontSizeToFitWidth = false
//        nameLbl.lineBreakMode = .byTruncatingTail
        // Initialization code
    }

    @IBAction func playMusic(_ sender: Any) {
    }
}
