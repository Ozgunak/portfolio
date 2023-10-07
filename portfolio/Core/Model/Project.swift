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
    var coverImageURL: String?
    var detailImageUrls: [String]
    //    var comments: [Comment]
    var timeStamp: Timestamp
    var videoUrl: String?
    var user: DBUser?
}

extension Project {
    static var MOCK_PROJECT: Project = Project(
        id: "hrClczREDHQROEFzCBod",
        ownerUid: "S8FRTEJwbpcqJcNvLLb7XFbp5pH2",
        projectTitle: "Test Project Title",
        description: "This project written with SwiftUI. Share your interests.",
        likes: [],
        coverImageURL: Optional("https://firebasestorage.googleapis.com:443/v0/b/reservations-5ea6e.appspot.com/o/projects%2FA4492A87-B9B0-4AE3-83C7-89981B846513?alt=media&token=2cb666ab-ac53-4453-991e-1e50003ded17"),
        detailImageUrls: [
            "https://firebasestorage.googleapis.com:443/v0/b/reservations-5ea6e.appspot.com/o/projects%2F20036C0E-8708-41CE-9520-213B2C760094?alt=media&token=8b91d53c-17e2-4bf5-8d4b-c0497c3767aa",
            "https://firebasestorage.googleapis.com:443/v0/b/reservations-5ea6e.appspot.com/o/projects%2F5842BAF4-C78E-4AFA-8B3C-5B8BDA47396D?alt=media&token=154c022f-c486-4472-84f3-654bf117a2c0",
            "https://firebasestorage.googleapis.com:443/v0/b/reservations-5ea6e.appspot.com/o/projects%2F6DD60301-8CB3-480A-90B6-15C4E2A1E38C?alt=media&token=15677135-e35a-45cd-85d5-77be809cc15f"
        ],
        timeStamp: Timestamp(),
        videoUrl: nil,
        user: Optional(DBUser(id: "S8FRTEJwbpcqJcNvLLb7XFbp5pH2", username: "User 1", profileImageURL: Optional("https://firebasestorage.googleapis.com:443/v0/b/reservations-5ea6e.appspot.com/o/profileImages%2FF640F87E-3BB9-4174-BEE2-28481FDDFF62?alt=media&token=6e650eb0-e1e4-42bf-a661-b61e35c53d94"), fullName: Optional("Ozgun Aksoy"), title: Optional("IOS dev"), email: "1@2.com", joinDate: Optional(Timestamp()), followers: nil, following: nil, github: "github", projects: nil))
    )
    
    static var MOCK_PROJECTS: [Project] = [ MOCK_PROJECT, MOCK_PROJECT, MOCK_PROJECT,
                                            Project(
                                                id: "hrClczREDHQROEFzCBod",
                                                ownerUid: "S8FRTEJwbpcqJcNvLLb7XFbp5pH2",
                                                projectTitle: "Test Project Title",
                                                description: "This project written with SwiftUI. Share your interests.",
                                                likes: [],
                                                coverImageURL: Optional("https://firebasestorage.googleapis.com:443/v0/b/reservations-5ea6e.appspot.com/o/projects%2FA4492A87-B9B0-4AE3-83C7-89981B846513?alt=media&token=2cb666ab-ac53-4453-991e-1e50003ded17"),
                                                detailImageUrls: [
                                                    "https://firebasestorage.googleapis.com:443/v0/b/reservations-5ea6e.appspot.com/o/projects%2F20036C0E-8708-41CE-9520-213B2C760094?alt=media&token=8b91d53c-17e2-4bf5-8d4b-c0497c3767aa",
                                                    "https://firebasestorage.googleapis.com:443/v0/b/reservations-5ea6e.appspot.com/o/projects%2F5842BAF4-C78E-4AFA-8B3C-5B8BDA47396D?alt=media&token=154c022f-c486-4472-84f3-654bf117a2c0",
                                                    "https://firebasestorage.googleapis.com:443/v0/b/reservations-5ea6e.appspot.com/o/projects%2F6DD60301-8CB3-480A-90B6-15C4E2A1E38C?alt=media&token=15677135-e35a-45cd-85d5-77be809cc15f"
                                                ],
                                                timeStamp: Timestamp(),
                                                videoUrl: nil,
                                                user: Optional(DBUser(id: "S8FRTEJwbpcqJcNvLLb7XFbp5pH2", username: "User 1", profileImageURL: Optional("https://firebasestorage.googleapis.com:443/v0/b/reservations-5ea6e.appspot.com/o/profileImages%2FF640F87E-3BB9-4174-BEE2-28481FDDFF62?alt=media&token=6e650eb0-e1e4-42bf-a661-b61e35c53d94"), fullName: Optional("Ozgun Aksoy"), title: Optional("IOS dev"), email: "1@2.com", joinDate: Optional(Timestamp()), followers: nil, following: nil, projects: nil))
                                            )
    ]
}
