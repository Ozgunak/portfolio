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
    var navStackNeeded: Bool
    @Environment(\.dismiss) var dismiss

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
            } else {
                let _ = print("else block")
            }
        }
        .task {
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
        .sheet(isPresented: $showSignInView) {
            NavigationStack {
                LoginView(showSignInView: $showSignInView)
            }
        }
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
    ProfileFactory(user: DBUser.MOCK_USER, navStackNeeded: true)
}
