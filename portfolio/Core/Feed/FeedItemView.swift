//
//  FeedItemView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import SwiftUI
import Kingfisher

struct FeedItemView: View {
    var body: some View {
        VStack {
            header()
            
            postBody
            
            Divider()
        }
    }
}

extension FeedItemView {
    func header() -> some View {
        HStack {
            Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                            .foregroundColor(Color(.systemGray4))
//            CircularProfileImageView(user: user)

       
            Text("Ozgun")
                .font(.subheadline)
                .fontWeight(.semibold)
                .padding(.leading, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
    }
    
    var postBody: some View {
        VStack {
            
            Text("iOS Dev")
                .font(.footnote)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                .padding(.top, 2)
            
                TabView {
                    ForEach(0...5, id: \.self) { index in
                        KFImage(URL(string: "https://imgv3.fotor.com/images/blog-richtext-image/part-blurry-image.jpg"))
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
    FeedItemView()
}
