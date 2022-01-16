
import Foundation
import FirebaseDatabase


final class DatabaseManger {
    
    static let shared = DatabaseManger()
    private let database = Database.database().reference()
    private let onlineUserDatabase = Database.database().reference(withPath: "Online")
    
    func removeDataBaseObservers() {
        database.removeAllObservers()
    }
    
    func removeUserDatabaseObserever() {
        onlineUserDatabase.removeAllObservers()
    }
    
}

// MARK:- grocery management
extension DatabaseManger {
    
    func addGrocery(item: GroceryItem) {
        database.child("Grocery/\(item.name.capitalized)").setValue(
            ["user": item.username,
             "isDone": item.isDone]
        )}
    
    func deleteGrocery(item: GroceryItem){
        database.child("Grocery/\(item.name.capitalized)").removeValue()
    }
    
    func updateGroceryStatus(item: GroceryItem){
        database.child("Grocery/\(item.name.capitalized)").updateChildValues(
            ["isDone" : item.isDone])
    }
    
    func updateGroceryItemName(oldItem: GroceryItem, newItemName: String) {
        database.child("Grocery/\(oldItem.name.capitalized)").removeValue()
        addGrocery(item: GroceryItem(name: newItemName, username: oldItem.username, isDone: oldItem.isDone))
    }
    
    func groceryItemExists(with itemName: String, completion: @escaping ((Bool)->(Void))) {
        //item name make sure it is safe
        database.child("Grocery/\(itemName.capitalized)").observeSingleEvent(of: .value) { snapshot in
            guard snapshot.value as? String != nil else {
                completion(false) //the item doesn't exists, we can add it
                return
            }
            print(snapshot.value as Any)
            completion(true) //the item exists in the database
        }
    }
    
    func getGroceryList(completion: @escaping ([GroceryItem]) -> Void) {
        database.child("Grocery").queryOrdered(byChild: "isDone").observe(.value) { snapshot in
            print("snapshot values: \(String(describing: snapshot.value))")
            var list: [GroceryItem] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let value = snapshot.value as? [String: Any] {
                    print("we are in ------------------------------------")
                    let name = snapshot.key
                    let user = value["user"] as! String
                    let isDone = value["isDone"] as! Bool
                    print(name, user, isDone)
                    list.append(GroceryItem(name: name, username: user, isDone: isDone))
                }
            }
            completion(list)
        }
    }
}

// MARK:- users management
extension DatabaseManger {
    func getOnlineUsers(completion: @escaping ([User]) -> Void) {
        onlineUserDatabase.observe(.value) { snapshot in
            print("snapshot values: \(String(describing: snapshot.value))")
            var list: [User] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let value = snapshot.value as? String {
                    let name = value
                    let isOnline = true
                    let user = User(name: name, email: "email", isOnline: isOnline)
                    print(user)
                    list.append(user)
                }
            }
            completion(list)
        }
    }
    
    
    public func userExists(with email:String, completion: @escaping ((Bool) -> Void)) {
        // will return true if the user email does exist already
        database.child("Users/\(email)").observeSingleEvent(of: .value) {
            snapshot in
            guard snapshot.value as? String != nil else {
                // let's create the account
                completion(false)
                return
            }
            completion(true) // the caller knows the email exists already
        }
    }
    
    public func insertUser(with user: User){
        database.child("Users/\(user.getSafeEmail())").setValue(
            ["username":user.name, "isOnline": user.isOnline])
    }
    
    func setCurrentUserOnline(safeEmail: String, id: String) {
            let currentUser = self.onlineUserDatabase.child(id)
            currentUser.setValue(safeEmail)
            currentUser.onDisconnectRemoveValue()
    }
    
    func removeUserOnline(id: String) {
        onlineUserDatabase.child(id).removeValue()
    }
}


