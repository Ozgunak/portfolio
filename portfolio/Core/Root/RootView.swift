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
                        return
                    }
                    user = try await FirestoreManager.shared.fetchUser(userId: authUser.uid)
                } catch {
                    print("Error: root auth \(error.localizedDescription)")
                }
                
                
                
            }
    }
}

#Preview {
    RootView()
}
