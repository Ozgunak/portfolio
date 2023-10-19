//
//  ProfileFactory.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import SwiftUI

struct ProfileFactory: View {
    @State var authUser: AuthDataResultModel?
    let isVisitor: Bool
    var navStackNeeded: Bool
    @Environment(\.dismiss) var dismiss
    @State private var isShown: Bool = false
    @Binding var tabIndex: Int
    @State private var showSignInView: Bool = false
    @StateObject var viewModel: ProfileFactoryViewModel
    
    init(user: DBUser?, isVisitor: Bool, navStackNeeded: Bool, tabIndex: Binding<Int>) {
        self.isVisitor = isVisitor
        self.navStackNeeded = navStackNeeded
        self._tabIndex = tabIndex
        self._viewModel = StateObject(wrappedValue: ProfileFactoryViewModel(user: user))
    }

    var body: some View {
        VStack {
            if let user = viewModel.user, isVisitor {
                ProfileView(user: user)
                    .navigationBarBackButtonHidden()
            } else if viewModel.userSession?.isAnonymous == true {
                SignUpPromoteView()
                    .navigationBarBackButtonHidden()
            } else if let user = viewModel.user, navStackNeeded, user.isCurrentUser {
                NavigationStack {
                    UserProfileView(user: user, showSignInView: $showSignInView)
                        .navigationBarBackButtonHidden()
                }
            } else if let user = viewModel.user, user.isCurrentUser {
                UserProfileView(user: user, showSignInView: $showSignInView)
                    .navigationBarBackButtonHidden()
            }
        }
        .task {
            do {
                try await viewModel.fetchProfile()
            } catch {
                print("Error: fetching profile \(error.localizedDescription)")
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
    ProfileFactory(user: DBUser.MOCK_USER, isVisitor: false, navStackNeeded: true, tabIndex: .constant(4))
}
