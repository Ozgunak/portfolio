//
//  ProfileView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import SwiftUI
import Kingfisher

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel
    
    init(user: DBUser) {
        self._viewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }
    
    var body: some View {
        
//        ZStack {
            
            ScrollView {
                VStack {
                    OzProfileImageView(urlString: viewModel.user.profileImageURL, size: .xxLarge)
                    
                    Text(viewModel.user.fullName ?? viewModel.user.username)
                        .font(.largeTitle)
                        .lineLimit(1)
                    Text(viewModel.user.title ?? "")
                        .font(.title2)
                        .lineLimit(1)
                    Divider()
                    if let bio = viewModel.user.bio {
                        Text("About Me")
                            .font(.subheadline)
                        Text(bio)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                        
                        Divider()
                    }
                    
                    SocialLinksView(user: viewModel.user)

                    ForEach(viewModel.projects) { project in
                        if project.isPublic {
                            ProjectItemView(project: project)
                        }
                    }
                }
            }
//            .frame(width: UIScreen.main.bounds.width)
            

            //            ProfileOptionOne(user: viewModel.user, projects: viewModel.projects)
//        }
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
        .background(
            Image(viewModel.user.backgroundImage ?? "bg3")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea())
        .task {
            do {
                try await viewModel.fetchUserProjects()
            } catch {
                print("Error: fetch profile view \(error.localizedDescription)")
            }
        }
        
        
    }
}

extension ProfileOptionOne {
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

struct ProfileOptionOne: View {
    let user: DBUser
    let projects: [Project]
    var body: some View {
        VStack {
            ProfileHeaderView(user: user, projectCount: projects.count)
            
            SocialLinksView(user: user)
            
            actionButton
            
            Divider()
            ForEach(projects) { project in
                ProjectItemView(project: project)
            }
            //                ProjectCoversView(projects: viewModel.projects, isLoading: viewModel.isLoading)
        }
    }
}
