
import UIKit
//add keyboard return btn delegate
class GroceryListViewController: UIViewController {
    
    @IBOutlet var textFieldNewItem : UITextField?
    @IBOutlet weak var tableViewGroceries: UITableView?
    
    var groceryList : [GroceryItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewGroceries?.delegate = self
        tableViewGroceries?.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.addKeyboardObserver()
        self.hideKeyboardWhenTappedAround()
        DatabaseManger.shared.getGroceryList { data in
            //check if data is empty?
            self.groceryList = data
            print("data is :")
            print(self.groceryList)
            self.tableViewGroceries?.reloadData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardObserver()
        DatabaseManger.shared.removeObservers()
    }
    
    @IBAction func addItemBtnPressed(_ sender: UIButton) {
        guard let itemName = textFieldNewItem?.text, !itemName.isEmpty else {
            print("the item text field is empty")
            Alert.error(message: "No Item Found!", self)
            return
        }
        DatabaseManger.shared.groceryItemExists(with: itemName) { [weak self] exists in
            guard let strongSelf = self else { return }
            guard !exists else {
                Alert.error(message: "User already exists", strongSelf)
                return
            }
            // ISSUE: " " is added
            // TODO: check if item already exists in database //do I need that? duplicates are overriden
            let newItem = GroceryItem(name: itemName, username: "current user")
            print(newItem)
            DatabaseManger.shared.addGrocery(item: newItem)
            //update tableview
        }
        textFieldNewItem?.text = ""
        textFieldNewItem?.resignFirstResponder()
    }
    
}


extension GroceryListViewController: UITableViewDelegate, UITableViewDataSource { //this deals with everything related to table views

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceryList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") as! GroceryItemTableViewCell
        //set up cell
        cell.setupCell(item: groceryList[indexPath.row])
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

