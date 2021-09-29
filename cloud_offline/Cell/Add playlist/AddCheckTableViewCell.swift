//
//  AddCheckTableViewCell.swift
//  cloud_offline
//
//  Created by ThanhThanh on 19/08/2021.
//

import UIKit

class AddCheckTableViewCell: UITableViewCell {

    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var artistLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var artworkImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        artworkImage.layer.cornerRadius = 10
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
