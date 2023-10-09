//
//  ProjectItemView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-05.
//

import SwiftUI
import Kingfisher

struct ProjectItemView: View {
    var project: Project = Project.MOCK_PROJECT
    var body: some View {
        
        VStack(alignment: .center) {
            option1
        }
    }
}

extension ProjectItemView {
    var option1: some View {
        NavigationLink {
            ProjectView(project: project)
        } label: {
            VStack(spacing: 0) {
                Text(project.projectTitle)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                if !project.description.isEmpty {
                    VStack(spacing: 0) {
                        Text(project.description)
                            .font(.footnote)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 4)
                            .padding(.horizontal)
    //                        .background(.ultraThinMaterial)
                    }
                }
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack() {
                            ZStack(alignment: .bottomLeading) {
                                if let coverImageURL = project.coverImageURL{
                                    KFImage(URL(string: coverImageURL))
                                        .resizable()
                                        .scaledToFill()
                                        .frame(height: 200)
                                } else {
                                    ZStack {
                                        
                                        LinearGradient(colors: [.green, .blue, .yellow], startPoint: .topLeading, endPoint: .bottomTrailing)
                                        .opacity(0.8)
                                        Text(project.projectTitle)
                                            .font(.title)
                                            .foregroundStyle(.white)
                                            .padding()
                                            .background(.thinMaterial)
                                    }
                                    .frame(height: 200)

                                }
                                
                            }
                            .containerRelativeFrame(.horizontal, count: 2, spacing: 10.0)
                            .clipShape(.rect(cornerRadius: 15))

                        ForEach(project.detailImageUrls, id: \.self) { url in
                            KFImage(URL(string: url))
                                .resizable()
                                .scaledToFill()
                                .frame(height: 200)
                                .containerRelativeFrame(.horizontal, count: 2, spacing: 10.0)
                                .clipShape(.rect(cornerRadius: 15))
                                
                        }
                                        

                    }
                    .scrollTargetLayout()
                }
                .contentMargins(32, for: .scrollContent)
                .scrollTargetBehavior(.viewAligned)
                .frame(height: 230)
                Divider()
            }
        }

    }
    
    var option2: some View {
        VStack {
            HStack {
                if let coverImageURL = project.coverImageURL{
                    KFImage(URL(string: coverImageURL))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(.rect(cornerRadius: 15))
                }
                
            }
            .padding(.top)
            
            ScrollView(.horizontal) {
                HStack {
                    VStack {
                        Text(project.projectTitle)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .lineLimit(2)
                        Text(project.description)
                            .font(.footnote)
                            .lineLimit(3)
                    }
                    .multilineTextAlignment(.center)
                    .frame(width: 100)
                    
                    ForEach(project.detailImageUrls, id: \.self) { url in
                        KFImage(URL(string: url))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(.rect(cornerRadius: 15))
                    }
                }
            }
            .contentMargins(30, for: .scrollContent)
        }
    }
    
    var option3: some View {
        VStack(spacing: 0) {
            HStack {
                if let coverImageURL = project.coverImageURL{
                    KFImage(URL(string: coverImageURL))
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .clipShape(.rect(cornerRadius: 15))
                }
                
            }
            .padding(.top)
            
            Text(project.projectTitle)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(1)
            
            Text(project.description)
                .font(.footnote)
                .lineLimit(1)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    VStack {
                        
                    }
                    .multilineTextAlignment(.center)
                    .frame(width: 100)
                    
                    ForEach(project.detailImageUrls, id: \.self) { url in
                        KFImage(URL(string: url))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(.rect(cornerRadius: 15))
                    }
                }
            }
            .contentMargins(30, for: .scrollContent)
            
            
        }
    }
    
    var option4: some View {
        VStack(spacing: 0) {
//            HStack {
//                if let coverImageURL = project.coverImageURL{
//                    KFImage(URL(string: coverImageURL))
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 64, height: 64)
//                        .clipShape(.rect(cornerRadius: 15))
//                }
//                
//            }
//            .padding(.top)
            
            Text(project.projectTitle)
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(1)
            
            Text(project.description)
                .font(.footnote)
                .lineLimit(1)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    
                    ForEach(project.detailImageUrls, id: \.self) { url in
                        KFImage(URL(string: url))
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(.rect(cornerRadius: 15))
                    }
                }
            }
            .contentMargins(30, for: .scrollContent)
            
            
        }
    }
}

#Preview {
    NavigationStack {
        ProjectItemView()
    }
}
