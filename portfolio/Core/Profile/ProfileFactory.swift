//
//  ProfileFactory.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import SwiftUI

struct ProfileFactory: View {
    @State var user: DBUser = DBUser.MOCK_USER
    let navStackNeeded: Bool
    @Environment(\.dismiss) var dismiss

    @State private var showSignInView: Bool = false

    var body: some View {
        VStack {
            NavigationStack {
                UserProfileView(user: user, showSignInView: $showSignInView)
                    .navigationBarBackButtonHidden()
            }
        }
        .task {
            do {
                let authUser = try AuthenticationManager.shared.getAuthUser()
                user = try await FirestoreManager.shared.fetchUser(userId: authUser.uid)
                self.showSignInView = authUser.isAnonymous == true

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
    ProfileFactory(user: DBUser.MOCK_USER, navStackNeeded: false)
}
