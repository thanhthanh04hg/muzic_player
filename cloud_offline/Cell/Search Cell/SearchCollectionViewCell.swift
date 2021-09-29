//
//  SearchCollectionViewCell.swift
//  cloud_offline
//
//  Created by ThanhThanh on 16/09/2021.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var artistLbl: UILabel!
    @IBOutlet weak var mainImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        mainImage.layer.cornerRadius = 10 
    }

}
