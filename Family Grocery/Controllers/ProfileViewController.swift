
import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var tableViewFamilyProfile: UITableView!
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewFamilyProfile.delegate = self
        tableViewFamilyProfile.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DatabaseManger.shared.getOnlineUsers(completion: { [weak self] users in
            guard let strongSelf = self else { return }
            strongSelf.users = users
            print("profile view: users are: \(strongSelf.users)")
            strongSelf.tableViewFamilyProfile.reloadData()
            
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        DatabaseManger.shared.removeUserDatabaseObserever()
    }
    
    @IBAction func logoutBtnPressed(_ sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: {
            [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            do {
                let id = Auth.auth().currentUser?.uid
                try Auth.auth().signOut()
                DatabaseManger.shared.removeUserOnline(id: id!)
                if let newModal = strongSelf.storyboard?.instantiateViewController(withIdentifier: "login") {
                    newModal.modalTransitionStyle = .crossDissolve
                    newModal.modalPresentationStyle = .fullScreen
                    strongSelf.present(newModal, animated: true, completion: nil)
                }
            }
            catch {
                print("failed to logout")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as! UserTableViewCell
        cell.setupCell(user: users[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
