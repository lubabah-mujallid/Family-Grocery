//
//  UserTableViewCell.swift
//  Family Grocery
//
//  Created by administrator on 12/01/2022.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet var labelUser: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
