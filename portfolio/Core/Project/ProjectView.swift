//
//  ProjectView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-06.
//

import SwiftUI
import Kingfisher

struct ProjectView: View {
    @Environment(\.dismiss) var dismiss
    @State var project: Project = Project.MOCK_PROJECT
    var body: some View {
        
        ScrollView {
            VStack {
                if let url = project.coverImageURL {
                    KFImage(URL(string: url))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(.rect(cornerRadius: 15))
                        .shadow(radius: 10)
                }
                Text(project.projectTitle)
                    .font(.title)
                Text(project.description)
                    .font(.subheadline)
                TabView {
                    ForEach(project.detailImageUrls, id: \.self) { url in
                        ZStack {
                            KFImage(URL(string: url))
                                .resizable()
                                .scaledToFill()
                                .containerRelativeFrame(.horizontal)
                                .frame(height: 500)
                                .clipShape(.rect)
                                .blur(radius: 106.0, opaque: true)
                            KFImage(URL(string: url))
                                .placeholder({
                                    ProgressView()
                                })
                                .resizable()
                                .scaledToFit()
                                .containerRelativeFrame(.horizontal)
                                .clipShape(.rect)
                        }
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                .frame(minHeight: 500)
                .background(.clear)
                
                //                    Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .onTapGesture {
                            dismiss()
                        }
                }
                ToolbarItem(id: "1", placement: .topBarTrailing) {
                    if let github = project.github {
                        NavigationLink {
                            WebScreen(url: github)
                        } label: {
                            Image("github")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                        }
                    } else {
                        EmptyView()
                    }
                }
                ToolbarItem(id: "2", placement: .topBarTrailing) {
                    NavigationLink {
                        // new message to project creator
                    } label: {
                        Image(systemName: "plus.bubble")
                            .resizable()
                            .scaledToFill()
                    }
                }
//                ToolbarItem(id: "3", placement: .topBarTrailing) {
                    //                    if let user = project.user {
//                    NavigationLink {
//                        ProfileFactory(user: project.user, isVisitor: !project.user.isCurrentUser, navStackNeeded: false)
//                    } label: {
//                        OzProfileImageView(urlString: project.user.profileImageURL, size: .small)
//                    }
                    //                                      }
//                }
//                ToolbarItem(placement: .topBarTrailing) {
//
//                }
                
            }
            .navigationBarBackButtonHidden()
        }
        .background {
            BackgroundImages(rawValue: project.backgroundImage ?? "bg3")?.image
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
}



#Preview {
    NavigationStack {
        ProjectView()
    }
}
