//
//  FirestoreManager.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-02.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct FirestoreManager {
    static let shared = FirestoreManager()
    
    private init () {}
    
    private let usersCollectionRef = Firestore.firestore().collection("users")
    
    func createUser(authUser: AuthDataResultModel, username: String) async throws {
        let user = DBUser(id: authUser.uid, username: username, email: authUser.email)
        try await usersCollectionRef.document(authUser.uid).setData(user.dictionary)
    }
    
    func fetchUser(userId: String) async throws -> DBUser {
        return try await usersCollectionRef.document(userId).getDocument(as: DBUser.self)
    }
    
    func fetchAllUsers() async throws -> [DBUser] {
        let snapshot = try await usersCollectionRef.getDocuments()
        return snapshot.documents.compactMap({ try? $0.data(as: DBUser.self) })
    }
    
    func updateUserInfo(userId: String, data: [String: Any]) async throws {
        try await usersCollectionRef.document(userId).updateData(data)
    }
    
}