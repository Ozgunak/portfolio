//
//  Project.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-02.
//

import Foundation
import Firebase

struct Project: Identifiable, Hashable, Codable {
    let id: String
    var ownerUid: String
    var projectTitle: String
    var description: String
    var likes: [String]
    var coverImageURL: String
    var detailImageUrls: [String]
    //    var comments: [Comment]
    var timeStamp: Timestamp
    var videoUrl: String?
    var user: DBUser?
}

extension Project {
    static var MOCK_PROJECT: Project = Project(id: "V6EQWLy4OhUSdHmZFKGW",
                                            ownerUid: "2IoptF5NE5bYFJyxzWSJXXeGz762",
                                            projectTitle: "Title",
                                            description: "1",
                                            likes: [],
                                               coverImageURL: "https://firebasestorage.googleapis.com:443/v0/b/instagramswiftui-df1ee.appspot.com/o/postImages%2FD4B7CC18-A260-47E8-A21A-E71CB54B9DA5?alt=media&token=e2d2e155-3397-4751-80db-39a3861d2be9", 
                                               detailImageUrls: ["https://firebasestorage.googleapis.com:443/v0/b/instagramswiftui-df1ee.appspot.com/o/postImages%2FD4B7CC18-A260-47E8-A21A-E71CB54B9DA5?alt=media&token=e2d2e155-3397-4751-80db-39a3861d2be9", "https://firebasestorage.googleapis.com:443/v0/b/instagramswiftui-df1ee.appspot.com/o/postImages%2FD4B7CC18-A260-47E8-A21A-E71CB54B9DA5?alt=media&token=e2d2e155-3397-4751-80db-39a3861d2be9", "https://firebasestorage.googleapis.com:443/v0/b/instagramswiftui-df1ee.appspot.com/o/postImages%2FD4B7CC18-A260-47E8-A21A-E71CB54B9DA5?alt=media&token=e2d2e155-3397-4751-80db-39a3861d2be9"],
                                            //                                      comments: [],
                                            timeStamp: Timestamp(),
                                            user: nil)
    
    static var MOCK_PROJECTS: [Project] = [ MOCK_PROJECT, MOCK_PROJECT, MOCK_PROJECT ]
}
