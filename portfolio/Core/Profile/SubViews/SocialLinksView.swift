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
    var githubLink: String?
    var linkedinLink: String?
    var body: some View {
            HStack {
                if let github = githubLink{
                    NavigationLink {
                        WebScreen(url: github)
                    } label: {
                        LabeledContent("GitHub") {
                            Image("github")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 44, height: 44)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        .background(.ultraThickMaterial)
                        .clipShape(.rect(cornerRadius: 16))
//                        .containerRelativeFrame(.horizontal) { len, _ in
//                            abs(len / 2 - 16)
//                        }
                    }

                }
                if let linkedin = linkedinLink {
                    NavigationLink {
                        WebScreen(url: linkedin)
                    } label: {
                        LabeledContent("LinkedIn") {
                            Image("linkedin")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 44, height: 44)
                        }
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                        .background(.ultraThickMaterial)
                        .clipShape(.rect(cornerRadius: 16))
//                        .containerRelativeFrame(.horizontal) { len, _ in
//                            abs(len / 2 - 16)
//                        }
                    }
                }
            }
            
        .padding(.horizontal)
    }
}

#Preview {
    SocialLinksView(githubLink: "github.com", linkedinLink: "linkedin.com")
}
