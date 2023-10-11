//
//  ProjectManager.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-03.
//

import Foundation
import Firebase

struct ProjectManager {
    static let shared = ProjectManager()
    
    private init() {}
    
    private let projectsCollectionPath = Firestore.firestore().collection(FirestorePath.projects.rawValue)
    
    func fetchHomeFeedProjects() async throws -> [Project] {
        let snapshot = try await projectsCollectionPath.order(by: "timeStamp", descending: true).getDocuments()
        let unfilteredProjects = snapshot.documents.compactMap( { try? $0.data(as: Project.self) })
        var projects = unfilteredProjects.filter( { $0.isPublic })
        for i in 0 ..< projects.count {
            let project = projects[i]
            let ownerUid = project.ownerUid
            let projectUser = try await FirestoreManager.shared.fetchUser(userId: ownerUid)
            projects[i].user = projectUser
        }
        return projects
    }
    
    func fetchUserProject(userId: String) async throws -> [Project] {
        let snapshot = try await projectsCollectionPath.whereField("ownerUid", isEqualTo: userId).getDocuments()

        return snapshot.documents.compactMap({ try? $0.data(as: Project.self) }).sorted(by: { $0.timeStamp.seconds > $1.timeStamp.seconds } )
    }

}
