//
//  ProfileFactory.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import SwiftUI

struct ProfileFactory: View {
    @State var user: DBUser?
    @State var authUser: AuthDataResultModel?
    let isVisitor: Bool
    var navStackNeeded: Bool
    @Environment(\.dismiss) var dismiss
    @State private var isShown: Bool = false
    @Binding var tabIndex: Int
    @State private var showSignInView: Bool = false


    var body: some View {
        VStack {
            if let user, navStackNeeded, user.isCurrentUser {
                NavigationStack {
                    UserProfileView(user: user, showSignInView: $showSignInView)
                        .navigationBarBackButtonHidden()
                }
            } else if let user, user.isCurrentUser {
                UserProfileView(user: user, showSignInView: $showSignInView)
                    .navigationBarBackButtonHidden()
            } else if let user, isVisitor {
                ProfileView(user: user)
                    .navigationBarBackButtonHidden()

            }
        }
        .task {
            if !isVisitor {
                do {
                    authUser = try AuthenticationManager.shared.getAuthUser()
                    if let authUser {
                        self.showSignInView = authUser.isAnonymous == true
                        if !authUser.isAnonymous {
                            user = try await FirestoreManager.shared.fetchUser(userId: authUser.uid)
                        }
                    }
                } catch {
                    print("Error: fetching user \(error.localizedDescription)")
                }
            }
        }
//        .sheet(isPresented: $showSignInView) {
//            NavigationStack {
//                LoginView(showSignInView: $showSignInView)
//            }
//        }
        .sheet(isPresented: $showSignInView, onDismiss: {
            Task {
                do {
                    authUser = try AuthenticationManager.shared.getAuthUser()
                    if let authUser {
                        if isShown {
                            tabIndex = 0
                            isShown = false 
                            return
                        }
                        self.showSignInView = authUser.isAnonymous == true
                        if !authUser.isAnonymous {
                            user = try await FirestoreManager.shared.fetchUser(userId: authUser.uid)
                        }
                        isShown = true
                    }
                } catch {
                    print("Error: fetching user \(error.localizedDescription)")
                }
            }
        }, content: {
            NavigationStack {
                LoginView(showSignInView: $showSignInView)
            }
        })
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .onTapGesture {
                        dismiss()
                    }
            }
        }
    }
}

#Preview {
    ProfileFactory(user: DBUser.MOCK_USER, isVisitor: false, navStackNeeded: true, tabIndex: .constant(4))
}
