//
//  UserProfileViewModel.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import Foundation

@MainActor
class UserProfileViewModel: ObservableObject {
    @Published var user: DBUser
//    @Published var posts = [Project]()
    @Published var isLoading: Bool = false
    init(user: DBUser) {
        self.user = user
    }
    
//    func fetchUserPosts() async throws {
//        isLoading = true
//        self.posts = try await PostManager.fetchUserPost(userId: user.id)
//        
//        for i in 0 ..< posts.count {
//            posts[i].user = self.user
//        }
//        isLoading = false
//    }
    
//    func fetchUser() async throws {
//        self.user = try await UserManager.getUser(userID: user.id)
//    }
}

