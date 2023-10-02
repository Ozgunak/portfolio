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
            HStack(spacing: 30){
                CircularProfileImageView(user: user)
                Spacer()
                ProfileStatsView(count: projectCount, title: "Projects")
                ProfileStatsView(count: user.followers?.count ?? 0, title: "Followers")
                ProfileStatsView(count: user.following?.count ?? 0, title: "Following")
            }
            .padding(.horizontal)


            
            VStack(alignment: .leading ) {
                Text(user.fullName ?? "-")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(user.bio ?? "-")
                    .font(.subheadline)
            }
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    ProfileHeaderView(user: DBUser.MOCK_USER, projectCount: 10)
}
