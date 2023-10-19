//
//  ProfileFactoryViewModel.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-19.
//

import Foundation
import Firebase
import Combine

@MainActor
class ProfileFactoryViewModel: ObservableObject {
    @Published var userSession: User?
    @Published var user: DBUser?

    var subscriptions = Set<AnyCancellable>()
    init(user: DBUser?) {
        self.user = user
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        AuthenticationManager.shared.$userSession.sink { [weak self] userSession in
            self?.userSession = userSession
            if let userSession, userSession.isAnonymous != true {
                Task { try? await self?.fetchProfile() }
            }
        }
        .store(in: &subscriptions)
    }
    
    func fetchProfile() async throws {
        if let userSession, userSession.isAnonymous != true {
            user = try await FirestoreManager.shared.fetchUser(userId: userSession.uid)
        }
    }
}
