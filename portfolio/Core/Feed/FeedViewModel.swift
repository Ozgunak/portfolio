//
//  FeedViewModel.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-03.
//

import Foundation

@MainActor
class FeedViewModel: ObservableObject {
    @Published var projects: [Project] = []
    
    func fetchProjects() async throws {
        projects = try await ProjectManager.shared.fetchHomeFeedProjects()
    }
}
