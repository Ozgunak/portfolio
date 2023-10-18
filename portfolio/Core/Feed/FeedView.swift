//
//  FeedView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import SwiftUI

struct FeedView: View {
    @State private var isLoading: Bool = false
    @StateObject var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                if isLoading {
                    ProgressView()
                        .frame(width: 100, height: 100)
                }
                LazyVStack(spacing: 20) {
                    ForEach(viewModel.projects) { project in
                        FeedItemView(project: project)                        
                    }
                }
            }
            .toolbar {
//                ToolbarItem(placement: .topBarLeading) {
//                    Image(systemName: <#T##String#>)
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 100)
//                }
//                ToolbarItem(placement: .topBarTrailing) {
//                    NavigationLink {
//                        AllMessagesView()
//                            .navigationBarBackButtonHidden()
//                    } label: {
//                        Image(systemName: "bubble")
//                            .resizable()
//                            .scaledToFill()
//                    }
//                }
                
                // TODO: Notifications
            }
            .refreshable {
                try? await viewModel.fetchProjects()
            }
            .task {
                do {
                    isLoading = true
                    try await viewModel.fetchProjects()
                    isLoading = false
                } catch {
                    print("Error: error fetching projects \(error.localizedDescription)")
                }
            }
        }
    }
}


#Preview {
    FeedView()
}
