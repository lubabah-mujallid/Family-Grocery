
import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {

    @IBOutlet var textFieldRegisterUser: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldRegisterUser[0].delegate = self
        textFieldRegisterUser[1].delegate = self
        textFieldRegisterUser[2].delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func registerBtnPressed(_ sender: Any) {
        
        
        guard let username = textFieldRegisterUser[0].text,
              let email = textFieldRegisterUser[1].text,
              let password = textFieldRegisterUser[2].text,
              !username.isEmpty
        else {
            print("username is empty")
            Alert.error(message: "Username is empty", self)
            return
        }
        let user = User(name: username, email: email)
        print("#1 suscceed")
        DatabaseManger.shared.userExists(with: user.getSafeEmail(), completion: { [weak self] exists in
            guard let strongSelf = self else { return }
            guard !exists else {
                Alert.error(message: "User already exists", strongSelf)
                return
            }
            print("#2 succeed")
            Auth.auth().createUser(withEmail: email, password: password, completion: { authResult , error  in
                guard authResult != nil, error == nil else {
                    print("Error creating user, error:\(String(describing: error)), result:\(String(describing: authResult))")
                    Alert.error(message: error!.localizedDescription, strongSelf)
                    return
                }
                print("#3 succeed")
                print(user)
                DatabaseManger.shared.insertUser(with: user)
                print("Created User: \(user)")
                strongSelf.performSegue(withIdentifier: "registerSegue", sender: strongSelf)
//                if let newModal = strongSelf.storyboard?.instantiateViewController(withIdentifier: "tabBar") {
//                    newModal.modalTransitionStyle = .crossDissolve
//                    newModal.modalPresentationStyle = .fullScreen
//                    strongSelf.present(newModal, animated: true, completion: nil)
//                }
            })
        })
        
    }

}

//this extensions is for the text fields return btns
extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case textFieldRegisterUser[0]:
                textFieldRegisterUser[1].becomeFirstResponder()
            case textFieldRegisterUser[1]:
                textFieldRegisterUser[2].becomeFirstResponder()
            default:
                registerBtnPressed(textField)
        }
        return true
    }
}
