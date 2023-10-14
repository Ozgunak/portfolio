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
            try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
    
    func isValidInput() -> Bool {
        let emailText = (email.count > 5 && email.contains("@"))
        let passText = (password.count > 5)
        return (emailText && passText)
    }
}
