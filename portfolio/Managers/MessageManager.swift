//
//  MessageManager.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-17.
//

import Foundation
import Firebase

struct MessageManager {
    
    static let shared = MessageManager()
    
    private init() {}
    
    private let messageRef = Firestore.firestore().collection(K.FirestoreConstant.messages)
    
    func addMessage(message: Message) async throws {
        let _ = try await messageRef.document(message.ownerUid).collection(K.FirestoreConstant.messageList).document(message.toId).collection(K.FirestoreConstant.chats).addDocument(data: message.dictionary)
        let _ = try await messageRef.document(message.ownerUid).collection(K.FirestoreConstant.messageList).document(message.toId).setData([K.FirestoreConstant.toId: message.toId], merge: true)
        let _ = try await messageRef.document(message.toId).collection(K.FirestoreConstant.messageList).document(message.ownerUid).collection(K.FirestoreConstant.chats).addDocument(data: message.dictionary)
        let _ = try await messageRef.document(message.toId).collection(K.FirestoreConstant.messageList).document(message.ownerUid).setData([K.FirestoreConstant.toId: message.ownerUid], merge: true)
    }
    
    func fetchMessagesUsers(userId: String) async throws -> [String] {
        let snap = try await messageRef.document(userId).collection(K.FirestoreConstant.messageList).getDocuments()
        var idList: [String] = []
        for doc in snap.documents {
            let data = doc.data()
            let id = data[K.FirestoreConstant.toId] as? String
            if let id {
                idList.append(id)
            }
        }
        return idList
//        let users = snap.documents.compactMap({ try? $0.data(as: DBUser.self) })
//        return users
        
    }
    
    func fetchUsers(userIdList: [String]) async throws -> [DBUser] {
        var userList = [DBUser]()
        for i in 0..<userIdList.count {
            let user = try await FirestoreManager.shared.fetchUser(userId: userIdList[i])
            userList.append(user)
        }
        return userList
    }
    
    func fetchUsersMessages(userId: String) async throws -> [Message] {
        let snap = try await messageRef.document(userId).collection(K.FirestoreConstant.messageList).getDocuments()
        let messages = snap.documents.compactMap({ try? $0.data(as: Message.self) })
        return messages
    }
    
    func fetchMessages(userId: String, messangerId: String, completion: @escaping ([Message]) -> Void ) {
        let _ = messageRef.document(userId).collection(K.FirestoreConstant.messageList).document(messangerId).collection(K.FirestoreConstant.chats).addSnapshotListener { snapshot, error in
            if let error {
                print("Error: listening messages \(error.localizedDescription)")
            }
            if let snapshot {
                var messages = snapshot.documents.compactMap( { try? $0.data(as: Message.self)})
                messages.sort(by: { $0.timeStamp.dateValue() < $1.timeStamp.dateValue() })
                completion(messages)
            }
        }
    }

    func fetchUsersWithMessages(userId: String, otherUsers: [DBUser]) async throws -> [Message] {
        var messages = [Message]()
        for user in otherUsers {
            let snap = try await messageRef.document(userId).collection(K.FirestoreConstant.messageList).document(user.id).collection(K.FirestoreConstant.chats).order(by: K.FirestoreConstant.timeStamp).getDocuments()
            let message = snap.documents.compactMap( { try? $0.data(as: Message.self) } )
            if let last = message.last, !message.isEmpty {
                messages.append(last)
            }
        }
        messages.sort(by: { $0.timeStamp.dateValue() > $1.timeStamp.dateValue() } )
        return messages
    }
     
    
    
    func sharePost(toUsers users: [DBUser], project: Project, messageText: String) async throws {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        for user in users {
            let message = Message(messageId: UUID().uuidString, ownerUid: userId, toId: user.id, messageText: messageText, project: project, timeStamp: Timestamp())
            let data = try Firestore.Encoder().encode(message)
            let _ = try await messageRef.document(message.ownerUid).collection(message.toId).addDocument(data: data)
            let _ = try await messageRef.document(message.toId).collection(message.ownerUid).addDocument(data: data)
//            try await addMessage(message: message)
        }
        
    }
}
