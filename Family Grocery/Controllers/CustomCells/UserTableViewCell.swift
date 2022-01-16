//
//  UserTableViewCell.swift
//  Family Grocery
//
//  Created by administrator on 12/01/2022.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet var labelUser: [UILabel]!
    
    func setupCell(user: User) {
        labelUser[0].text = user.name
        checkUser(isOnline: user.isOnline)
    }
    
    func checkUser(isOnline: Bool) {
        if isOnline {
            labelUser[1].text = "online"
            labelUser[1].textColor = .systemGreen
        }
        else {
            labelUser[1].text = "offline"
            labelUser[1].textColor = .lightGray
        }
    }
    
}
