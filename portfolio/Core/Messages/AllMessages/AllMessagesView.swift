//
//  AllMessagesView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-17.
//

import SwiftUI

struct AllMessagesView: View {
//    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: AllMessagesViewModel = AllMessagesViewModel()
    
    var body: some View {
        NavigationStack {
            
            VStack {
                ScrollView{
                    LazyVStack {
                        if viewModel.messages.isEmpty {
                            ContentUnavailableView("No Messages Yet", systemImage: "message", description: Text("Start new conversation."))
                        } else {
                            ForEach(viewModel.messages) { message in
                                NavigationLink {
                                    if let messanger = viewModel.users.first(where: { $0.id == message.toId }) {
                                        MessageView(messanger: messanger)
                                            .navigationBarBackButtonHidden()
                                    } else if let messanger = viewModel.users.first(where: { $0.id == message.ownerUid }) {
                                        MessageView(messanger: messanger)
                                            .navigationBarBackButtonHidden()
                                    }
                                } label: {
                                    MessageUserView(message: message)
                                        .padding(.bottom, 4)
                                }
                                
                                
                                
                            }
                        }
                    }
                }
                .task {
                    try? await viewModel.fetchMessagedUsers()
                    try? await viewModel.fetchUsers()
                    try? await viewModel.fetchMessages()
                }
                .navigationTitle("Messages")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
//                    ToolbarItem(placement: .topBarLeading) {
//                        Image(systemName: "chevron.left")
//                            .imageScale(.large)
//                            .onTapGesture {
//                                dismiss()
//                            }
//                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        NavigationLink {
                            NewMessageView()
                                .navigationBarBackButtonHidden()
                        } label: {
                            Image(systemName: "plus.bubble")
                        }
                        
                    }
                }
            }
        }
    }
}

#Preview {
    AllMessagesView()
}
