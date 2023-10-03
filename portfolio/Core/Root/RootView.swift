//
//  RootView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import SwiftUI

struct RootView: View {    
    @State var user: DBUser?
    
    var body: some View {
        VStack {
            if let user {
                TabBarView(user: user)
            } else {
                ProgressView()
            }
        }
            .task {
                do {
                    guard let authUser = try? AuthenticationManager.shared.getAuthUser() else {
                        try await AuthenticationManager.shared.signInAnonymously()
                        print("Signed in Anonymously")
                        return
                    }
                    print("Signed in with \(authUser.uid)")
                    user = try await FirestoreManager.shared.fetchUser(userId: authUser.uid)
                    print("got db user \(user)")
                } catch {
                    print("Error: auth \(error.localizedDescription)")
                }
                
                
                
            }
    }
}

#Preview {
    RootView()
}
