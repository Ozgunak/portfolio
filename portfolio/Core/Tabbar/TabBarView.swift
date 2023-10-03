//
//  TabBarView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import SwiftUI

struct TabBarView: View {
    let user: DBUser
    @State private var selectedIndex = 0
    
    var body: some View {
        TabView(selection: $selectedIndex) {
            FeedView()
                .onAppear {
                    selectedIndex = 0
                }
                .tabItem { Image(systemName: "house") }
                .tag(0)
                        
            Text("Search")
                .onAppear {
                    selectedIndex = 1
                }
                .tabItem { Image(systemName: "magnifyingglass") }
                .tag(1)
            
            
            AddProject(tabIndex: $selectedIndex)
                .onAppear {
                    selectedIndex = 2
                }
                .tabItem { Image(systemName: "plus.circle") }
                .tag(2)
            
            
            Text("Projects")
                .onAppear {
                    selectedIndex = 3
                }
                .tabItem { Image(systemName: "heart") }
                .tag(3)
            
            
            ProfileFactory(user: user, navStackNeeded: true)
                .onAppear {
                    selectedIndex = 4
                }
                .tabItem { Image(systemName: "person") }
                .tag(4)
            
        }
    }
}

#Preview {
    TabBarView(user: DBUser.MOCK_USER)
}
