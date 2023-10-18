//
//  NewMessageView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-17.
//

import SwiftUI

struct NewMessageView: View {
    @Environment(\.dismiss) var dismiss
    @State private var searchText: String = ""
    @StateObject var viewModel = NewMessageViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 12) {
                    if !searchText.isEmpty && viewModel.searchResultUsers.isEmpty {
                        ContentUnavailableView("User not found", systemImage: "person.fill.questionmark")
                    }
                    ForEach(searchText.isEmpty ? viewModel.users : viewModel.searchResultUsers) { user in
                        NavigationLink{
                            MessageView(messanger: user)
                                .navigationBarBackButtonHidden()
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
            .navigationTitle("New Message")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .onTapGesture {
                            dismiss()
                        }
                }
            }
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
    NewMessageView()
}
