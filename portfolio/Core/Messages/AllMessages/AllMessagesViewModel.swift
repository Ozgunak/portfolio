//
//  AllMessagesViewModel.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-17.
//

import Foundation
import Firebase
import Combine

@MainActor
class AllMessagesViewModel: ObservableObject {
    @Published var users = [DBUser]()
    @Published var messages: [Message] = []
    @Published var userIds = [String]()
    @Published var userSession: User?
    var subscriptions = Set<AnyCancellable>()
    init() {
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        AuthenticationManager.shared.$userSession.sink { userSession in
            self.userSession = userSession
        }
        .store(in: &subscriptions)
    }
    
    func fetchMessagedUsers() async throws {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        userIds = try await MessageManager.shared.fetchMessagesUsers(userId: userId)
    }
    
    func fetchUsers() async throws {
        users = try await MessageManager.shared.fetchUsers(userIdList: userIds)
    }
    
    func fetchMessages() async throws {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        messages = try await MessageManager.shared.fetchUsersWithMessages(userId: userId, otherUsers: users)
    }
    
    
}
