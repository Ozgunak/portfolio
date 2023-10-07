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
        ZStack {
            Image("bg2")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
                .blur(radius: 1)
            ScrollView {
                VStack {
                    if let url = project.coverImageURL {
                        KFImage(URL(string: url))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipShape(.rect(cornerRadius: 15))
                            .shadow(radius: 10)
                    }
                    Text(project.projectTitle)
                        .font(.title)
                    Text(project.description)
                        .font(.subheadline)
                    TabView {
                        ForEach(project.detailImageUrls, id: \.self) { url in
                            KFImage(URL(string: url))
                                .placeholder({
                                    ProgressView()
                                })
                                .resizable()
                                .scaledToFill()
                                .containerRelativeFrame(.horizontal)
                                .clipShape(.rect(cornerRadius: 8))
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
                    ToolbarItem(placement: .topBarTrailing) {
                        if let github = project.user?.github {
                            Image("github")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 40)
                                .onTapGesture {
                                    dismiss()
                                }
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        if let user = project.user {
                            NavigationLink {
                                ProfileFactory(user: user, isVisitor: !user.isCurrentUser, navStackNeeded: false)
                            } label: {
                                OzProfileImageView(urlString: user.profileImageURL, size: .small)
                            }
                        }
                    }
                    
                }
            .navigationBarBackButtonHidden()
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProjectView()
    }
}