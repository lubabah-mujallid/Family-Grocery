

import UIKit

protocol GroceryTableViewCellDelegate: AnyObject {
    func checkboxTapped(_ sender: UIButton)
}

class GroceryItemTableViewCell: UITableViewCell {
    
    var delegate: GroceryTableViewCellDelegate?

    @IBOutlet weak var btnCheckmark: UIButton!
    @IBOutlet var labelGroceryItems: [UILabel]!
    
    func setupCell(item: GroceryItem) {
        labelGroceryItems[0].text = item.username
        labelGroceryItems[1].text = item.name
        checkImageView(item.isDone)
    }
    
    func checkImageView(_ isDone: Bool) {
        if isDone {
            btnCheckmark.setImage(UIImage(named: "Checked"), for: .normal)
            labelGroceryItems[0].textColor = .gray
            labelGroceryItems[1].textColor = .lightGray
        }
        else {
            btnCheckmark.setImage(UIImage(named: "NotChecked"), for: .normal)
            labelGroceryItems[0].textColor = .black
            labelGroceryItems[1].textColor = .black
        }
    }

    @IBAction func checkmarkBtnPressed(_ sender: UIButton) {
        delegate?.checkboxTapped(sender)
    }
    
}
