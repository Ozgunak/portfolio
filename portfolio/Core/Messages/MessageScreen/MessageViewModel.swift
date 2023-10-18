//
//  MessageViewModel.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-17.
//

import Foundation
import Firebase

@MainActor
class MessageViewModel: ObservableObject {
    @Published var user: DBUser?
    @Published var messages: [Message] = []
    @Published var messageText: String = ""
    @Published var messanger: DBUser
    
    init(messanger: DBUser) {
        self.messanger = messanger
        Task { try await getUserMessages() }
    }
    
    func getUserMessages() async throws {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        user = try await FirestoreManager.shared.fetchUser(userId: userId)
        // get messages
//        if let messanger = messanger {
            MessageManager.shared.fetchMessages(userId: userId, messangerId: messanger.id, completion: { messages in
                self.messages = messages
            })
//        }
    }
    
    func addMessage() async throws {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        try await MessageManager.shared.addMessage(message: Message(messageId: UUID().uuidString,
                                                          ownerUid: userId,
                                                          toId: messanger.id,
                                                          messageText: messageText,
                                                          timeStamp: Timestamp()))
        
    }
}
