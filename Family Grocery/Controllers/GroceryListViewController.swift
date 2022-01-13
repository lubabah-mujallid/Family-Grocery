
import UIKit


class GroceryListViewController: UIViewController { //contains all UI elemnts outlets and actions
    
    @IBOutlet var textFieldNewItem : UITextField?
    @IBOutlet weak var tableViewGroceries: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //DatabaseManger.shared.test()
        tableViewGroceries.delegate = self
        tableViewGroceries.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardObserver()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardObserver()
    }
    
    @IBAction func addItemBtnPressed(_ sender: UIButton) {
        
    }
}


extension GroceryListViewController: UITableViewDelegate, UITableViewDataSource { //this deals with everything related to table views
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20 //change this later
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! GroceryItemTableViewCell
        //set up cell
        cell.labelGroceryItems[0].text = "item number #\(indexPath.row)"
        return cell
    }
    
    // TODO : add in swipe actions to delete and edit and complete
//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        return UISwipeActionsConfiguration(actions: [UIContextualAction()])
//    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        <#code#>
//    }

}

