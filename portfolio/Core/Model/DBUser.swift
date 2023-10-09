//
//  DBUser.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import Foundation
import Firebase

struct DBUser: Identifiable, Hashable, Codable {
    let id: String
    var username: String
    var profileImageURL: String?
    var fullName: String?
    var title: String?
    let email: String
    var bio: String?
    var joinDate: Timestamp? = Timestamp()
    var followers: [String]?
    var following: [String]?
    var github: String?
    var linkedin: String?
    var projects: [Project]?
    
    var isCurrentUser: Bool {
        guard let currentUid = Auth.auth().currentUser?.uid else { return false }
        print("current User? \(currentUid == id)")
        return currentUid == id
    }
    
    var dictionary: [String:Any] {
        return ["id": id, "username": username as Any, "profileImageURL": profileImageURL as Any, "fullName": fullName as Any, "title": title as Any, "email": email as Any, "bio": bio as Any, "followers": followers as Any, "following": following as Any, "joinDate": Timestamp(), "github": github as Any, "linkedin": linkedin as Any]
    }
}

extension DBUser {
    static var MOCK_USERS: [DBUser] = [
        DBUser(id: UUID().uuidString, username: "First ", profileImageURL: nil, fullName: "First ", title: "first", email: "first.com"),
        DBUser(id: UUID().uuidString, username: "second ", profileImageURL: nil, fullName: "second ", title: "second", email: "second.com"),
        DBUser(id: UUID().uuidString, username: "third ", profileImageURL: nil, fullName: "third ", title: "third", email: "third.com"),
        DBUser(id: UUID().uuidString, username: "fourth ", profileImageURL: nil, fullName: "fourth ", title: "fourth", email: "fourth.com"),
        DBUser(id: UUID().uuidString, username: "fifth ", profileImageURL: nil, fullName: "fifth ", title: "fifth", email: "fifth.com")
    ]
    
    static var MOCK_USER: DBUser = DBUser(id: "xXmosFckXJeQZn8pyHTxDSKmuB73", username: "oz", profileImageURL: Optional("https://as2.ftcdn.net/v2/jpg/05/79/83/69/1000_F_579836914_yo2WTNUIDANJPGGvhXSGMRc6bfCmUGM7.jpg"), fullName: Optional("Ozgun Ak"), title: Optional("iOS Developer"), email: "1@2.com", bio: "iOS Developer for 4 years of experience, Worked with different groups, Loves creating content.", joinDate: Timestamp(), followers: Optional(["2IoptF5NE5bYFJyxzWSJXXeGz762"]), following: Optional(["2IoptF5NE5bYFJyxzWSJXXeGz762", "H0vHXan5MjZUqpPSf5ppg7YKzwJ3"]))
}
