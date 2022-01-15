
import Foundation
import UIKit

class Alert {
    static func error(message: String, _ view: UIViewController) {
        let alert = UIAlertController.init(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
}
