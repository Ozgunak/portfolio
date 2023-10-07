//
//  SocialLinksView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-06.
//

import SwiftUI

enum SocialMedia: Identifiable, CaseIterable {
    case github
    case linkedin
    case dribble
    case x
    case facebook
    case instagram
    
    var id: Self { self }
    
    var title: String {
        switch self {
        case .github: "Github"
        case .linkedin: "LinkedIn"
        case .dribble: "Dribble"
        case .x: "X"
        case .facebook: "Facebook"
        case .instagram: "Instagram"
        }
    }
    
    var imageName: String {
        switch self {
        case .github: "github"
        case .linkedin: "linkedin"
        case .dribble: "dribble"
        case .x: "x"
        case .facebook: "facebook"
        case .instagram: "instagram"
        }
    }
    
//    func createLink(link: String) -> some View {
//        switch self {
//        case .github:
//               return HStack {
//                    Image(self.imageName)
//                        .resizable()
//                    Text(self.title)
//                }
//        case .linkedin:
//            return HStack {
//                Image(self.imageName)
//                    .resizable()
//                Text(self.title)
//            }
//        case .dribble:
//            return HStack {
//                Image(self.imageName)
//                    .resizable()
//                Text(self.title)
//            }
//        case .x:
//            return HStack {
//                Image(self.imageName)
//                    .resizable()
//                Text(self.title)
//            }
//        case .facebook:
//            return HStack {
//                Image(self.imageName)
//                    .resizable()
//                Text(self.title)
//            }
//        case .instagram:
//            return HStack {
//                Image(self.imageName)
//                    .resizable().scaledToFill()
//                    .frame(width: 44, height: 44)
//                Text(self.title)
//            }
//        }
//    }
}



struct SocialLinksView: View {
    var user: DBUser
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
//                SocialMedia.github.createLink(link: user.github ?? "")
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
            .padding(1)
        }
        .padding(.horizontal)
    }
}

#Preview {
    SocialLinksView(user: DBUser.MOCK_USER)
}
