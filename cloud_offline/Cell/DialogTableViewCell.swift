//
//  DialogTableViewCell.swift
//  cloud_offline
//
//  Created by ThanhThanh on 18/08/2021.
//

import UIKit

class DialogTableViewCell: UITableViewCell {

    @IBOutlet weak var checkBox: UIImageView!
    @IBOutlet weak var leftLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
