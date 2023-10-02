//
//  DBUser.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import Foundation

struct DBUser: Identifiable, Hashable, Codable {
    let id: String
    var username: String
    var profileImageURL: String?
    var fullName: String?
    var bio: String?
    let email: String
//    var joinDate: Timestamp? = Timestamp()
    var followers: [String]?
    var following: [String]?
    
//    var isCurrentUser: Bool {
//        guard let currentUid = Auth.auth().currentUser?.uid else { return false }
//        return currentUid == id
//    }
}

extension DBUser {
    static var MOCK_USERS: [DBUser] = [
        DBUser(id: UUID().uuidString, username: "First City", profileImageURL: nil, fullName: "First City", bio: "first", email: "first.com"),
        DBUser(id: UUID().uuidString, username: "second City", profileImageURL: nil, fullName: "second City", bio: "second", email: "second.com"),
        DBUser(id: UUID().uuidString, username: "third City", profileImageURL: nil, fullName: "third City", bio: "third", email: "third.com"),
        DBUser(id: UUID().uuidString, username: "fourth City", profileImageURL: nil, fullName: "fourth City", bio: "fourth", email: "fourth.com"),
        DBUser(id: UUID().uuidString, username: "fifth City", profileImageURL: nil, fullName: "fifth City", bio: "fifth", email: "fifth.com")
    ]
    
    static var MOCK_USER: DBUser = DBUser(id: "xXmosFckXJeQZn8pyHTxDSKmuB73", username: "oz", profileImageURL: Optional("https://as2.ftcdn.net/v2/jpg/05/79/83/69/1000_F_579836914_yo2WTNUIDANJPGGvhXSGMRc6bfCmUGM7.jpg"), fullName: Optional("Ozgun Ak"), bio: Optional("iOS"), email: "1@2.com", /*joinDate: nil,*/ followers: Optional(["2IoptF5NE5bYFJyxzWSJXXeGz762"]), following: Optional(["2IoptF5NE5bYFJyxzWSJXXeGz762", "H0vHXan5MjZUqpPSf5ppg7YKzwJ3"]))
}
