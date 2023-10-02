//
//  RootView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import SwiftUI

struct RootView: View {    

    var body: some View {
        TabBarView()
            .task {
                do {
                    guard let authUser = try? AuthenticationManager.shared.getAuthUser() else {
                        try await AuthenticationManager.shared.signInAnonymously()
                        print("Signed in Anonymously")
                        return
                    }
                    print("Signed in with \(authUser.uid)")
                } catch {
                    print("Error: auth \(error.localizedDescription)")
                }
                
                
                
            }
    }
}

#Preview {
    RootView()
}
