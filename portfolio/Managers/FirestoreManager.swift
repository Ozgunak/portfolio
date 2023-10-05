//
//  FirestoreManager.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-02.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

enum FirestorePath: String {
    case users
    case projects
    case videos
}

struct FirestoreManager {
    static let shared = FirestoreManager()
    
    private init () {}
    
    private let usersCollectionRef = Firestore.firestore().collection(FirestorePath.users.rawValue)
    private let projectCollectionRef = Firestore.firestore().collection(FirestorePath.projects.rawValue)

    func createUser(uid: String, email: String, username: String) async throws {
        let user = DBUser(id: uid, username: username, email: email)
        try await usersCollectionRef.document(uid).setData(user.dictionary)
    }
    
    func fetchUser(userId: String) async throws -> DBUser {
        return try await usersCollectionRef.document(userId).getDocument(as: DBUser.self)
    }
    
    func fetchAllUsers() async throws -> [DBUser] {
        let snapshot = try await usersCollectionRef.getDocuments()
        return snapshot.documents.compactMap({ try? $0.data(as: DBUser.self) })
    }
    
    func updateUserInfo(userId: String, data: [String: Any]) async throws {
        print("update user starts")
        try await usersCollectionRef.document(userId).setData(data, merge: true)
        print("update user ends")
    }
    
    func fetchProjects() async throws -> [Project] {
        let snapshot = try await projectCollectionRef.getDocuments()
        return snapshot.documents.compactMap({ try? $0.data(as: Project.self) })
    }
    
    func updateProjectVideo(projectId: String, videoUrl: String) async throws {
        try await projectCollectionRef.document(projectId).setData(["videoUrl": videoUrl], merge: true)
    }
}
