//
//  AuthenticationManager.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import Foundation
//import FirebaseAuth
import Firebase

final class AuthenticationManager {
    
    @Published var userSession: User?
    static let shared = AuthenticationManager()
    private init() {
        self.userSession = Auth.auth().currentUser
    }
    
    func getAuthUser() throws -> AuthDataResultModel {
        guard let user = Auth.auth().currentUser else { throw URLError(.badURL) }
        return AuthDataResultModel(user: user)
    }
    
    @MainActor
    @discardableResult
    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authData = try await Auth.auth().createUser(withEmail: email, password: password)
        userSession = authData.user
        return AuthDataResultModel(user: authData.user)
    }
    
    @MainActor
    @discardableResult
    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
        let authData = try await Auth.auth().signIn(withEmail: email, password: password)
        userSession = authData.user
        return AuthDataResultModel(user: authData.user)
    }
    
    @MainActor
    @discardableResult
    func signInAnonymously() async throws -> AuthDataResultModel {
        let authData = try await Auth.auth().signInAnonymously()
        userSession = authData.user
        return AuthDataResultModel(user: authData.user)
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)        
    }
    
    func updatePassword(password: String) async throws {
        guard let user = Auth.auth().currentUser else { throw URLError(.badURL) }
        try await user.updatePassword(to: password)
    }
    
//    @MainActor
    func signOut() throws {
        try Auth.auth().signOut()
        userSession = nil
    }
    
    @discardableResult
    func linkEmail(email: String, password: String) async throws -> AuthDataResultModel? {
        let credential = EmailAuthProvider.credential(withEmail: email, password: password)
        print("credential: \(credential)")
        guard let user = Auth.auth().currentUser else { throw URLError(.badURL) }
        print("\(user.uid) \(user.isAnonymous)")
        do {
            let authData = try await user.link(with: credential)
            print("auth \(authData)")
            return nil
//            return AuthDataResultModel(user: authData.user)
        } catch {
            print("Error:  \(error.localizedDescription)")
        }
        throw URLError(.badURL)
    }
}
