//
//  FeedItemView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import SwiftUI
import Kingfisher
import AVKit

struct FeedItemView: View {
    let project: Project
    var body: some View {
        VStack {
            header()
            
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
            
            Text(project.user?.bio ?? "Test bio")
                .font(.footnote)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 2)
            
            if let videoUrl = project.videoUrl, !videoUrl.isEmpty {
                var player = AVPlayer(url: URL(string: videoUrl)!)
                VideoPlayer(player: player)                    
                    .scaledToFit()
//                    .frame(height: 400)
                

            } else {
                TabView {
                    ForEach(project.detailImageUrls, id: \.self) { url in
                        KFImage(URL(string: url))
                            .placeholder({
                                ProgressView()
                            })
                            .resizable()
                            .scaledToFill()
                            .containerRelativeFrame(.horizontal)
                            .clipShape(.rect)
                    }
                }
                .tabViewStyle(.page)
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                .frame(height: 400)
            }
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
}
#Preview {
    FeedItemView(project: Project.MOCK_PROJECT)
}
