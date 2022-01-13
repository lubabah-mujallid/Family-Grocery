
import Foundation

struct User {
    let name: String
    let email: String
    
    // create a computed property safe email
    func getSafeEmail() -> String {
        var safeEmail: String
        safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}
