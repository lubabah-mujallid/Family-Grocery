
import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    @IBOutlet var textFieldLoginUser: [UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldLoginUser[0].delegate = self
        textFieldLoginUser[1].delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        // Firebase Login
        Auth.auth().signIn(withEmail: textFieldLoginUser[0].text!, password: textFieldLoginUser[1].text!, completion: {
            [weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }
            guard let result = authResult, error == nil else {
                print("Failed to log in user with email \(String(describing: authResult?.user.email))")
                Alert.error(message: error!.localizedDescription, strongSelf)
                return
            }
            let user = result.user
            print("logged in user: \(user)")
            // if this succeeds, dismiss
            strongSelf.performSegue(withIdentifier: "loginSegue", sender: strongSelf)
            
        })
    }
    
}

//this extensions is for the text fields return btns
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
            case textFieldLoginUser[0]:
                textFieldLoginUser[1].becomeFirstResponder()
            default:
                loginBtnPressed(textField)
        }
        return true
    }
}

