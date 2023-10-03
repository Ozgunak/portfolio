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
    @Published var projects = [Project]()
    @Published var isLoading: Bool = false
    init(user: DBUser) {
        self.user = user
        Task { try? await fetchUser() }
    }
    
    func fetchUserProjects() async throws {
        isLoading = true
        self.projects = try await ProjectManager.shared.fetchUserProject(userId: user.id)
        
        for i in 0 ..< projects.count {
            projects[i].user = self.user
        }
        isLoading = false
    }
    
    func fetchUser() async throws {
        user = try await FirestoreManager.shared.fetchUser(userId: user.id)
    }
}

