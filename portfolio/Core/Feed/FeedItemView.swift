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
    @StateObject var viewModel: FeedItemViewModel
    
    init(project: Project) {
        self._viewModel = StateObject(wrappedValue: FeedItemViewModel(project: project))
    }
    
    var body: some View {
        VStack {
            if let user = viewModel.project.user {
                NavigationLink {
                    ProfileFactory(user: user, isVisitor: !user.isCurrentUser, navStackNeeded: false, tabIndex: .constant(4))
                } label: {
                    header()
                }

            }
            NavigationLink {
                ProjectView(project: viewModel.project)
            } label: {
                postBody
            }

            
            
        }
        .padding(.vertical)
        .background(.ultraThinMaterial)
    }
}

extension FeedItemView {
    func header() -> some View {
        HStack {
            if let url = viewModel.project.user?.profileImageURL {
                OzProfileImageView(urlString: url, size: .small)
            }
            
            Text(viewModel.project.user?.username ?? "Test")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.leading, 4)
            
            Text(viewModel.project.timeStamp.dateValue().formatted(.relative(presentation: .numeric)))
                .font(.caption)
                .fontWeight(.thin)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }
    
    var postBody: some View {
        VStack {
            Text(viewModel.project.user?.title ?? "Test title")
                .font(.footnote)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 2)
            
            TabView {
                if let coverUrl = viewModel.project.coverImageURL, !coverUrl.isEmpty {
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
                            Text(viewModel.project.projectTitle)
                                .font(.title)
                                .padding(4)
                                .background(.thickMaterial)
                                .clipShape(.rect(cornerRadius: 8))
                            Text(viewModel.project.description)
                                .font(.footnote)
                                .padding(4)
                                .background(.ultraThickMaterial)
                                .clipShape(.rect(cornerRadius: 8))
                        }
                    }
                }
                ForEach(viewModel.project.detailImageUrls, id: \.self) { url in
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
                    like()
                } label: {
                    Image(systemName: "heart")
                        .foregroundColor(.accentColor)
                    Text("^[\(viewModel.project.likes.count) like](inflect: true)")
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
    
    private func like() {
        if viewModel.isLiked {
            Task { try await viewModel.unlike() }
        } else {
            Task { try await viewModel.like() }
        }
    }
}
#Preview {
    NavigationStack {
        FeedItemView(project: Project.MOCK_PROJECT)
    }
}
