//
//  AuthenticationManager.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
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

final class AuthenticationManager {
    
    static let shared = AuthenticationManager()
    private init() { }
    
    func getAuthUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else { throw URLError(.badURL) }
        return AuthDataResultModel(user: user)
    }
    
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authData = try await Auth.auth().createUser(withEmail: email, password: password)
        return AuthDataResultModel(user: authData.user)
    }
    
    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authData = try await Auth.auth().signIn(withEmail: email, password: password)
        return AuthDataResultModel(user: authData.user)
    }
    
    @discardableResult
    func signInAnonymously() async throws -> AuthDataResultModel {
        let authData = try await Auth.auth().signInAnonymously()
        return AuthDataResultModel(user: authData.user)
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)        
    }
    
    func updatePassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else { throw URLError(.badURL) }
        try await user.updatePassword(to: password)
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
    
    @discardableResult
    func linkEmail(email: String, password: String) async throws -> AuthDataResultModel? {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        print("credential: \(credential)")
        guard let user = Auth.auth().currentUser else { throw URLError(.badURL) }
        print("\(user.uid) \(user.isAnonymous)")
        do {
            var authData = try await user.updateEmail(to: email)
            authData = try await user.link(with: credential)
            print("linked")
            return nil
//            return AuthDataResultModel(user: authData.user)
        } catch {
            print("Error:  \(error.localizedDescription)")
        }
        throw URLError(.badURL)
    }
}
