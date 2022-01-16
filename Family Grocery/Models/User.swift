
import Foundation

struct User {
    var name: String
    var email: String
    var isOnline:Bool = false
    
    // create a computed property safe email
    func getSafeEmail() -> String {
        var safeEmail: String
        safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
