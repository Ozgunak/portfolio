//
//  ForgotViewModel.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-02.
//

import Foundation

@MainActor
class ForgotViewModel: ObservableObject {
    @Published var email: String = ""
    
    func resetPassword() async throws {
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
}
