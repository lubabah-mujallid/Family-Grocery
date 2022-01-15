

import UIKit

class GroceryItemTableViewCell: UITableViewCell {

    @IBOutlet var labelGroceryItems: [UILabel]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupCell(item: GroceryItem) {
        labelGroceryItems[0].text = item.name
        labelGroceryItems[1].text = item.username
    }

}
