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
                OzProfileImageView(urlString: user.profileImageURL)
                Spacer()
                ProfileStatsView(count: projectCount, title: "Projects")
                ProfileStatsView(count: user.followers?.count ?? 0, title: "Followers")
                ProfileStatsView(count: user.following?.count ?? 0, title: "Following")
            }
            .padding(.horizontal)


            
            HStack {
                VStack(alignment: .leading ) {
                    Text(user.fullName ?? "-")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    
                    Text(user.title ?? "-")
                        .font(.subheadline)
                }
                Spacer()
                HStack {
                    Image("github")
                        .resizable().scaledToFill()
                    .frame(width: 44, height: 44)
                    
                    Text("Github")
                        .font(.subheadline)
                }
                .padding(8)
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(lineWidth: 2)
                }
                HStack {
                    Image("linkedin")
                        .resizable().scaledToFill()
                    .frame(width: 44, height: 44)
                    
                    Text("LinkedIn")
                        .font(.subheadline)
                        .lineLimit(1)
                }
                .padding(8)
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(lineWidth: 2)
                }
            }
            .padding(.horizontal)

        }
    }
}

#Preview {
    ProfileHeaderView(user: DBUser.MOCK_USER, projectCount: 10)
}
