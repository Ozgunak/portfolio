//
//  AuthDataResultModel.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-02.
//

import Foundation
import FirebaseAuth

struct AuthDataResultModel {
    let uid: String
    let email: String?
    let photoUrl: String?
    let isAnonymous: Bool
    
    init(user: User) {
        self.email = user.email
        self.uid = user.uid
        self.photoUrl = user.photoURL?.absoluteString
        self.isAnonymous = user.isAnonymous
    }
}
