//
//  FeedItemViewModel.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-17.
//

import Foundation
import Firebase

@MainActor
class FeedItemViewModel: ObservableObject {
    @Published var project: Project
    let currentUserId = Auth.auth().currentUser?.uid

    var isLiked: Bool {
        if let currentUserId {
            return project.likes.contains(currentUserId)
        } else {
            return false
        }
    }
    
    init(project: Project) {
        self.project = project
    }
    
    func like() async throws {
        try await ProjectManager.shared.likeProject(project: project)
        if let currentUserId {
            project.likes.append(currentUserId)
                    
        }
    }
    
    func unlike() async throws {
        try await ProjectManager.shared.unlikeProject(project: project)
        if let currentUserId {
            project.likes.removeAll(where: { $0.contains(currentUserId) } )
        }
    }

}
