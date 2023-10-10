//
//  UserProfileView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import SwiftUI

struct UserProfileView: View {
    @StateObject var viewModel: UserProfileViewModel
    @State private var isPresented: Bool = false
    @Binding var showSignInView: Bool
    @State private var authUser: AuthDataResultModel? = nil

    init(user: DBUser, showSignInView: Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: UserProfileViewModel(user: user))
        self._showSignInView = showSignInView
    }
    
    
    var body: some View {
        
            ScrollView {
                VStack {

                    ProfileHeaderView(user: viewModel.user, projectCount: viewModel.projects.count)
                    
                    actionButton
                    
                    Divider()
                    ForEach(viewModel.projects) { project in
                        ProjectItemView(project: project)
                    }
//                    ProjectCoversView(projects: viewModel.projects, isLoading: viewModel.isLoading)
                    
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .background(
                Image(viewModel.user.backgroundImage ?? "bg3")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea())
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        
                        if let authUser, authUser.isAnonymous {
                            NavigationLink {
                                RegisterView(showSignInView: $showSignInView, isCredential: true)
                                    .navigationBarBackButtonHidden()
                            } label: {
                                Text("Create Account")
                            }
                        }
                        
                        if let authUser, !authUser.isAnonymous {
                            NavigationLink {
                                UpdatePasswordView()
                            } label: {
                                Text("Update Password")
                            }
                        }
                        
                        
                        Button("SignOut") {
                            try? AuthenticationManager.shared.signOut()
                            showSignInView = true
                        }
                    } label: {
                        Image(systemName: "line.3.horizontal")
                    }
                }
            }
            .fullScreenCover(isPresented: $isPresented) {
                Task { try await viewModel.fetchUser() }
            } content: {
                EditProfileView(user: viewModel.user)
            }
            .task {
                do {
                    authUser = try? AuthenticationManager.shared.getAuthUser()
                    try await viewModel.fetchUserProjects()

                } catch {
                    print("Error: <#description#> \(error.localizedDescription)")
                }
            }
            

            
        
    }
}

extension UserProfileView {
    
    var actionButton: some View {
        Button(action: {
            isPresented.toggle()
        }, label: {
            Text("Edit Profile")
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(width: 360, height: 32)
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(.gray, lineWidth: 1))
        })
    }
    
    
}

#Preview {
    NavigationStack {
        UserProfileView(user: DBUser.MOCK_USER, showSignInView: .constant(false))
    }
}
