//
//  RootView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import SwiftUI

struct RootView: View {    
    //    @State var user: DBUser?
    
    var body: some View {
        VStack {
            TabBarView()
        }
        .task {
            do {
                guard let authUser = try? AuthenticationManager.shared.getAuthUser() else {
                    try await AuthenticationManager.shared.signInAnonymously()
                    print("Signed in ananymously ")
                    return
                }
                print("signed in anonymous? \(authUser.isAnonymous)")
                //                    user = try await FirestoreManager.shared.fetchUser(userId: authUser.uid)
            } catch {
                print("Error: root auth \(error.localizedDescription)")
            }
            
            
            
        }
    }
}

#Preview {
    RootView()
}
