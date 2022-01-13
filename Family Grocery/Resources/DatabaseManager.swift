
import Foundation
import FirebaseDatabase


final class DatabaseManger {

    static let shared = DatabaseManger()
    private let database = Database.database().reference()

    public func test() {
        database.child("soy milk/user").setValue(["hello":"there 5000"])
        database.child("soy milk").setValue(["user":"lubabah"])
    }
}
