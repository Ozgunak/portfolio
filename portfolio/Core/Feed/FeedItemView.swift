//
//  FeedItemView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import SwiftUI
import Kingfisher
//import AVKit

struct FeedItemView: View {
    let project: Project
    var body: some View {
        VStack {
            if let user = project.user {
                NavigationLink {
                    ProfileFactory(user: user, isVisitor: !user.isCurrentUser, navStackNeeded: false)
                } label: {
                    header()
                }

            }
            postBody
            
        }
        .padding(.vertical)
        .background(.ultraThinMaterial)
    }
}

extension FeedItemView {
    func header() -> some View {
        HStack {
            if let url = project.user?.profileImageURL {
                OzProfileImageView(urlString: url, size: .small)
            }
            
            Text(project.user?.username ?? "Test")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.leading, 4)
            
            Text(project.timeStamp.dateValue().formatted(.relative(presentation: .numeric)))
                .font(.caption)
                .fontWeight(.thin)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
    
    var postBody: some View {
        VStack {
            Text(project.user?.title ?? "Test title")
                .font(.footnote)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 2)
            
            TabView {
                if let coverUrl = project.coverImageURL, !coverUrl.isEmpty {
                    ZStack {
                        KFImage(URL(string: coverUrl))
                            .placeholder({
                                ProgressView()
                            })
                            .resizable()
                            .scaledToFill()
                            .containerRelativeFrame(.horizontal)
                            .frame(height: 400)
                            .clipShape(.rect(cornerRadius: 15))
                            .blur(radius: 106.0, opaque: true)

                        VStack {
                            KFImage(URL(string: coverUrl))
                                .placeholder({
                                    ProgressView()
                                })
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(.rect(cornerRadius: 15))
                            Text(project.projectTitle)
                                .font(.title)
                                .padding(4)
                                .background(.thickMaterial)
                                .clipShape(.rect(cornerRadius: 8))
                            Text(project.description)
                                .font(.footnote)
                                .padding(4)
                                .background(.ultraThickMaterial)
                                .clipShape(.rect(cornerRadius: 8))
                        }
                    }
                }
                ForEach(project.detailImageUrls, id: \.self) { url in
                    ZStack {
                        KFImage(URL(string: url))
                            .placeholder({
                                ProgressView()
                            })
                            .resizable()
                            .scaledToFill()
                            .containerRelativeFrame(.horizontal)
                            .frame(height: 400)
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
            .frame(height: 400)
            HStack{
                Button {
                } label: {
                    Image(systemName: "heart")
                        .foregroundColor(.accentColor)
                    Text("^[\(8) like](inflect: true)")
                        .font(.footnote)
                        .padding(.trailing, 4)
                }
                Button {
                } label: {
                    Image(systemName: "bubble.right")
                    Text("^[\(8) comment](inflect: true)")
                        .font(.footnote)
                        .padding(.trailing, 4)
                }
                Button {
                } label: {
                    Image(systemName: "paperplane")
                    Text("Share")
                }
                .font(.footnote)
                .padding(.trailing, 4)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal)
            .padding(.top, 2)
        }
    }
    
    var videoSection: some View {
        /*  Video Section
         if let videoUrl = project.videoUrl, !videoUrl.isEmpty {
         var player = AVPlayer(url: URL(string: videoUrl)!)
         VideoPlayer(player: player)
         .scaledToFit()
         } */
        Text("Uncomment When Video Needed")
    }
}
#Preview {
    FeedItemView(project: Project.MOCK_PROJECT)
}
