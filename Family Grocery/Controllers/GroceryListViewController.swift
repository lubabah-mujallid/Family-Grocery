import FirebaseAuth
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
        textFieldNewItem?.delegate = self
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemBackground
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
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
        let user = User(name: "", email: Auth.auth().currentUser!.email!)
        DatabaseManger.shared.setCurrentUserOnline(safeEmail: user.getSafeEmail(), id: Auth.auth().currentUser!.uid)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.removeKeyboardObserver()
        print("GVC: view will disappear")
        DatabaseManger.shared.removeDataBaseObservers()
    }
    
    @IBAction func addItemBtnPressed(_ sender: Any) {
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
        cell.delegate = self
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, actionPerformed: @escaping (Bool)->()) in
            
            let alert = UIAlertController(title: "Delete Grocery Item", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { alertAction in actionPerformed(false)}))
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { alertAction in
                actionPerformed(true)
                DatabaseManger.shared.deleteGrocery(item: self.groceryList[indexPath.row])
            }))
            self.present(alert, animated: true, completion: nil)
        }
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, actionPerformed: @escaping (Bool)->()) in
            let item = self.groceryList[indexPath.row]
            let alert = UIAlertController(title: nil, message: "Change the item name", preferredStyle: .alert)
            alert.addTextField { UITextField -> Void in
                UITextField.text = item.name
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { alertAction in actionPerformed(false)}))
            alert.addAction(UIAlertAction(title: "change", style: .default, handler: { alertAction in
                if let textField = alert.textFields?[0], !textField.text!.isEmpty{
                    print("the user entered: \( textField.text!)")
                    DatabaseManger.shared.updateGroceryItemName(oldItem: item, newItemName: textField.text!)
                    actionPerformed(true)}
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        edit.backgroundColor = .systemTeal
        
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
}

extension GroceryListViewController: GroceryTableViewCellDelegate {
    
    
    func checkboxTapped(_ sender: UIButton) {
        if let indexPath = getCurrentCellIndexPath(sender) {
            var item = groceryList[indexPath.row]
            item.isDone.toggle()
            let cell = tableViewGroceries?.cellForRow(at: indexPath) as! GroceryItemTableViewCell
            cell.checkImageView(item.isDone)
            DatabaseManger.shared.updateGroceryStatus(item: item)
        }
    }
    
    func getCurrentCellIndexPath(_ sender: UIButton) -> IndexPath? {
        let buttonPosition:CGPoint = sender.convert(CGPoint.zero, to: tableViewGroceries)
        if let indexPath: IndexPath = tableViewGroceries?.indexPathForRow(at: buttonPosition) {
            return indexPath
        }
        return nil
    }
}

//this extensions is for the text fields return btns
extension GroceryListViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addItemBtnPressed(textField)
        return true
    }
}
