//
//  MyProjectsView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-03.
//

import SwiftUI

@MainActor
class MyProjectsViewModel: ObservableObject {
    @Published var projects: [Project] = []
    @Published var user: DBUser
    
    init(user: DBUser) {
        self.user = user
    }
    func fetchMyProjects() async throws {
        projects = try await ProjectManager.shared.fetchUserProject(userId: user.id)
    }
}

struct MyProjectsView: View {
    @StateObject var viewModel: MyProjectsViewModel
    @State private var isLoading: Bool = false

    init(user: DBUser) {
        self._viewModel = StateObject(wrappedValue: MyProjectsViewModel(user: user))
    }
    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
            } else {
                LazyVStack {
                    ForEach(viewModel.projects) { project in
                        FeedItemView(project: project)
                    }
                }
            }
        }
        .task {
            do {
                isLoading = true
                try await viewModel.fetchMyProjects()
                isLoading = false
            } catch {
                print("Error: fetching my projects \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    MyProjectsView(user: DBUser.MOCK_USER)
}
