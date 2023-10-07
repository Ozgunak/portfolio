//
//  ProfileHeaderView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import SwiftUI

struct ProfileHeaderView: View {
    let user: DBUser
    let projectCount: Int
    var body: some View {
        VStack {
            HStack(spacing: 16){
                OzProfileImageView(urlString: user.profileImageURL)
                
                VStack(alignment: .leading ) {
                    Text(user.fullName ?? "-")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text(user.title ?? "-")
                        .font(.subheadline)
                }
                Spacer()
                VStack(spacing: 20) {
                    ProfileStatsView(count: projectCount, title: "Projects")
                    ProfileStatsView(count: user.followers?.count ?? 0, title: "Followers")
                }
            }
            .padding(.horizontal)
            
        }
    }
}

#Preview {
    ProfileHeaderView(user: DBUser.MOCK_USER, projectCount: 10)
}
