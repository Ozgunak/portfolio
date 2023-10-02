//
//  FeedView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import SwiftUI

struct FeedView: View {
    @State private var isLoading: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                if isLoading {
                    ProgressView()
                        .frame(width: 100, height: 100)
                }
                LazyVStack(spacing: 20) {
                    ForEach(0...20, id: \.self) { index in
                        FeedItemView()                        
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
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
//                        AllMessagesView()
//                            .navigationBarBackButtonHidden()
                    } label: {
                        Image(systemName: "plus.bubble")
                            .resizable()
                            .scaledToFill()
                    }
                }
            }
            .refreshable {
//                try? await viewModel.fetchPosts()
            }
            .task {
//                do {
//                    isLoading = true
//                    try await viewModel.fetchPosts()
//                    isLoading = false
//                } catch {
//                    print("Error: error fetching posts \(error.localizedDescription)")
//                }
            }
        }
    }
}


#Preview {
    FeedView()
}
