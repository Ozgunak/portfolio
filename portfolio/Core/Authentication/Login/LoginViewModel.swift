//
//  LoginViewModel.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func login() async throws {
        if !email.isEmpty && !password.isEmpty {
            try await AuthenticationManager.shared.signInUser(email: email, password: password)
        }
    }
}
