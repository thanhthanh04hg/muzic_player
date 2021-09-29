//
//  UsualCollectionViewCell.swift
//  cloud_offline
//
//  Created by Macbook on 10/06/2021.
//

import UIKit

class UsualCollectionViewCell: UICollectionViewCell {
    @IBOutlet var label: UILabel!
    @IBOutlet var image: UIImageView!
    @IBOutlet weak var artistLbl: UILabel!
    @IBOutlet weak var button: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        image.roundCorners(cornerRadius: 10)
    }
    @IBAction func showAlertView(_ sender: Any) {
    }
    
}
