
import UIKit

class GroceryListViewController: UIViewController {
    @IBOutlet var textFieldNewItem : UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
          self.addKeyboardObserver()
        self.hideKeyboardWhenTappedAround()
      }

      override func viewWillDisappear(_ animated: Bool) {
          self.removeKeyboardObserver()
      }
    
}

