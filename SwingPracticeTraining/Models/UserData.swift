import Foundation
import FirebaseFirestore

class UserData {
    
    let username: String?
    let totalCount: Int?

    init(username: String?, totalCount: Int?) {
        self.username = username;
        self.totalCount = totalCount;
    }
    
}
