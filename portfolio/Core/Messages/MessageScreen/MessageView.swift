//
//  MessageView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-17.
//

import SwiftUI

import Firebase
import Kingfisher

struct MessageView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: MessageViewModel
    
    init(messanger: DBUser) {
        self._viewModel = StateObject(wrappedValue: MessageViewModel(messanger: messanger))
    }
    var body: some View {
        VStack {
            NavigationLink {
                ProfileFactory(user: viewModel.messanger, isVisitor: viewModel.user?.isCurrentUser ?? true, navStackNeeded: false, tabIndex: .constant(4))
            } label: {
                Text("Go to profile")
            }
            
            if viewModel.messages.isEmpty {
                ContentUnavailableView("No messages yet", systemImage: "tray.fill", description: Text("Start the conversation."))
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.messages) { message in
                                if message.toId == Auth.auth().currentUser?.uid {
                                    HStack {
                                        OzProfileImageView(urlString: viewModel.messanger.profileImageURL, size: .small)
                                        
                                        VStack(alignment: .leading) {
                                            
                                            // project ?
                                            
                                            Text(message.messageText)
                                                .padding(.vertical, 4)
                                                .padding(.horizontal, 6)
                                                .clipShape(.rect(cornerRadius: 6))
                                                .overlay(RoundedRectangle(cornerRadius: 6).stroke(.gray, lineWidth: 1))
                                            
                                            Text(message.timeStamp.dateValue().formatted(.relative(presentation: .numeric)))
                                                .font(.footnote)
                                                .fontWeight(.thin)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                        }
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal)
                                } else {
                                    HStack {
                                        Spacer()
                                        
                                        VStack(alignment: .trailing) {
                                            // project?
                                            
                                            Text(message.messageText)
                                                .padding(.vertical, 4)
                                                .padding(.horizontal, 6)
                                                .background(.thinMaterial)
                                                .clipShape(.rect(cornerRadius: 6))
                                            
                                            Text(message.timeStamp.dateValue().formatted(.relative(presentation: .numeric)))
                                                .font(.footnote)
                                                .fontWeight(.thin)
                                                .frame(maxWidth: .infinity, alignment: .trailing)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                        }
                    }
                }
            }
            Spacer()
            HStack {
                if let user = viewModel.user {
                    OzProfileImageView(urlString: user.profileImageURL, size: .small)
                }
                
                TextField("Message...", text: $viewModel.messageText, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                
                if !viewModel.messageText.isEmpty {
                    Button {
                        Task {
                            try await viewModel.addMessage()
                            viewModel.messageText = ""
                        }
                    } label: {
                        Text("Post")
                            .foregroundStyle(.blue)
                    }
                    
                }
            }
            .padding(.horizontal)
            
            
            
        }
        .navigationTitle(viewModel.messanger.username)
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
            try? await viewModel.getUserMessages()
        }
    }
}

extension MessageView {
    func projectView(project: Project) -> some View {
        HStack {

            NavigationLink {
//                PostsView(user: project.user, post: project)
//                    .navigationBarBackButtonHidden()
            } label: {
                VStack {
                    KFImage(URL(string: project.coverImageURL ?? ""))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 250, height: 250)
                        .clipped()
                        .clipShape(.rect(cornerRadius: 6))
                    Text(project.projectTitle)
                        .font(.footnote)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        MessageView(messanger: DBUser.MOCK_USER)
    }
}
