//
//  Message.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-17.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Message: Identifiable, Hashable, Codable {
    @DocumentID var id: String?
    var messageId: String
    var ownerUid: String
    var toId: String
    var messageText: String
    var project: Project?
    var timeStamp: Timestamp
    
    var dictionary: [String: Any] {
        return ["messageId": messageId, "ownerUid": ownerUid, "toId": toId, "messageText": messageText, "timeStamp": timeStamp]
    }
}

extension Message {
    static var MOCK_MESSAGE: Message = Message(
        id: "nVnIABCNFN6lKdx5D1fB",
        messageId: "19251B19-8728-4818-B487-E68D0A9E8C3D",
        ownerUid: "VJDEHdu4kQW3m3cNAE2ZtQXJp4x2",
        toId: "QaEmGjUCCEWsDUB26cdaCfDdY7O2",
        messageText: "Good timing!",
        project: nil,
        timeStamp: Timestamp()
    )
        
    
}

