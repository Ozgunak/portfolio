//
//  RegisterViewModel.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import Foundation

@MainActor
class RegistrationViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var username = ""
    
    func createUser() async throws {
        if !email.isEmpty && !password.isEmpty {
            let authUser = try await AuthenticationManager.shared.createUser(email: email, password: password)
            try await FirestoreManager.shared.createUser(uid: authUser.uid, email: email, username: username)
            email = ""
            password = ""
            username = ""
        }
    }
    
    
    func linkUser() async throws {
        if !email.isEmpty && !password.isEmpty {
            try await AuthenticationManager.shared.linkEmail(email: email, password: password)
            print("Linked user with email")
        }
    }
}
