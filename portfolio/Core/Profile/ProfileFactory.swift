//
//  ProfileFactory.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import SwiftUI

struct ProfileFactory: View {
    let user: DBUser
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
        .onAppear{
            let authUser = try? AuthenticationManager.shared.getAuthUser()
            self.showSignInView = authUser == nil
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
