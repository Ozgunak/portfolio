//
//  AllMessagesViewModel.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-17.
//

import Foundation
import Firebase

@MainActor
class AllMessagesViewModel: ObservableObject {
    @Published var users = [DBUser]()
    @Published var messages: [Message] = []
    @Published var userIds = [String]()
    
    func fetchMessagedUsers() async throws {
        guard let userId = Auth.auth().currentUser?.uid else { return }
//        users = try await FirestoreManager.shared.fetchAllUsers()
//        users.removeAll(where: { $0.id == Auth.auth().currentUser?.uid })
        userIds = try await MessageManager.shared.fetchMessagesUsers(userId: userId)
//        var messageUsers: [DBUser] = []
//        for i in 0..<messages.count {
//            let message = messages[i]
//            let user = try await FirestoreManager.shared.fetchUser(userId: message.toId)
//            messageUsers.append(user)
//        }
//        users = messageUsers
        print("userids after fetch \(userIds)")
    }
    
    func fetchUsers() async throws {
        users = try await MessageManager.shared.fetchUsers(userIdList: userIds)
        print("users after fetch \(users)")
    }
    
    func fetchMessages() async throws {
        guard let userId = Auth.auth().currentUser?.uid else { return }

        messages = try await MessageManager.shared.fetchUsersWithMessages(userId: userId, otherUsers: users)
        print("messages after fetch \(messages)")
    }
    
    
}
