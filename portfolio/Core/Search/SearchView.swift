//
//  SearchView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-04.
//

import SwiftUI

@MainActor
class SearchViewModel: ObservableObject {
    @Published var users = [DBUser]()
    @Published var searchResultUsers = [DBUser]()
    
    func fetchAllUsers() async throws {
        users = try await FirestoreManager.shared.fetchAllUsers()
        for i in 0 ..< users.count {
            let user = users[i]
            let projects = try await ProjectManager.shared.fetchUserProject(userId: user.id)
            users[i].projects = projects
        }
    }
}

struct SearchView: View {
    @State private var searchText: String = ""
    @StateObject var viewModel = SearchViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(searchText.isEmpty ? viewModel.users : viewModel.searchResultUsers) { user in
                        SearchItemView(user: user)
                    }
                }
                .padding(.top, 8)
                .searchable(text: $searchText, prompt: "Search...")
                .animation(.default, value: searchText)
                .onChange(of: searchText, initial: true) {
                    viewModel.searchResultUsers = viewModel.users.filter( { user in
                        user.username.lowercased().contains(searchText.lowercased())
                    })
                }
                
            }
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.inline)
            .task {
                do {
                    try await viewModel.fetchAllUsers()
                } catch {
                    print("Error: fetching users \(error.localizedDescription)")
                }
            }
        }
    }
}

#Preview {
    SearchView()
}

struct SearchItemView: View {
    let user: DBUser
    var body: some View {
        VStack {
            profileSection
            projectsSection
            
        }
    }
}

extension SearchItemView {
    var profileSection: some View {
        NavigationLink {
            ProfileFactory(user: user, isVisitor: !user.isCurrentUser, navStackNeeded: false)
        } label: {
            HStack {
                OzProfileImageView(urlString: user.profileImageURL, size: .small)
                VStack(alignment: .leading) {
                    Text(user.username)
                        .fontWeight(.semibold)
                    
                    if user.fullName != nil {
                        Text(user.fullName!.capitalized)
                    }
                }
                .font(.footnote)
                
                Spacer()
            }
            .padding(.horizontal)
        }
        
        
        
    }
    
    var projectsSection: some View {
        
        
        Group {
            if let projects = user.projects {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(projects) { project in
                            if project.isPublic {
                                NavigationLink {
                                    ProjectView(project: project)
                                } label: {
                                    VStack {
                                        OzProfileImageView(urlString: project.coverImageURL, size: .xLarge)
                                        Text(project.projectTitle)
                                            .font(.footnote)
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(width: 120, height: 120)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
