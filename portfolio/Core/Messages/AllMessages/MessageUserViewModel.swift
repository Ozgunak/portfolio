//
//  MessageUserViewModel.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-17.
//

import Foundation
import Firebase

@MainActor
class MessageUserViewModel: ObservableObject {
    @Published var message: Message
    @Published var messanger: DBUser?
    
    init(message: Message) {
        self.message = message
    }
    
    func getMessageUser() async throws {
        guard let user = try? AuthenticationManager.shared.getAuthUser() else { return }
        if message.toId == user.uid {
            messanger = try await FirestoreManager.shared.fetchUser(userId: message.ownerUid)
        } else {
            messanger = try await FirestoreManager.shared.fetchUser(userId: message.toId)
        }
    }
}
