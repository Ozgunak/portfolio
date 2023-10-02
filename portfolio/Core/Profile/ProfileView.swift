//
//  ProfileView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel

    init(user: DBUser) {
        self._viewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }
    
    var body: some View {
        
        ScrollView {
            VStack {
                
                ProfileHeaderView(user: viewModel.user, projectCount: 3)
                
                actionButton
                
//                PostGridView(posts: viewModel.posts, isLoading: viewModel.isLoading)
                
            }
        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            
        }
        
        
    }
}

extension ProfileView {
    var actionButton: some View {
        HStack {
            Button {
//                if viewModel.isFollowing() {
//                    Task {
//                        do {
//                            try await viewModel.unfollow()
//                        } catch {
//                            print("Error: unfollowing \(error.localizedDescription)")
//                        }
//                    }
//                } else {
//                    Task {
//                        do {
//                            try await viewModel.follow()
//                        } catch {
//                            print("Error: following \(error.localizedDescription)")
//                        }
//                    }
//                }
                
            } label: {
                Text("Follow")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(width: 170, height: 32)
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(.rect(cornerRadius: 6))
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(.gray, lineWidth: 1))
            }
            
            
//            NavigationLink {
//                MessageView(messanger: viewModel.user)
//                    .navigationBarBackButtonHidden()
//            } label: {
                Text("Message")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .frame(width: 170, height: 32)
                    .background(.white)
                    .foregroundStyle(.black)
                    .clipShape(.rect(cornerRadius: 6))
                    .overlay(RoundedRectangle(cornerRadius: 6).stroke(.gray, lineWidth: 1))
//            }
        }
    }
}

#Preview {
    ProfileView(user: DBUser.MOCK_USER)
}
