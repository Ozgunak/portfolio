//
//  ProjectCoversView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-03.
//

import SwiftUI
import Kingfisher

struct ProjectCoversView: View {
        let projects: [Project]
        var isLoading: Bool
        
        private let gridColumns: [GridItem] = [
            GridItem(.flexible(), spacing: 1),
            GridItem(.flexible(), spacing: 1),
            GridItem(.flexible(), spacing: 1)
        ]
    
        private let imageDimension: CGFloat = (UIScreen.main.bounds.width / 3) - 1
        
        
        var body: some View {
            VStack {
//                if isLoading {
//                    ProgressView()
//                        .frame(width: 250, height: 250)
//                } else {
                    LazyVGrid(columns: gridColumns, spacing: 1 ) {
                        ForEach(projects) { project in
//                            NavigationLink {
//                                ProjectView(user: project.user, project: project)
//                                    .navigationBarBackButtonHidden()
//                            } label: {
                                KFImage(URL(string: project.coverImageURL))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: imageDimension, height: imageDimension)
                                    .clipped()
//                            }
                        }
                    }
//                }
            }
        }
}

#Preview {
    ProjectCoversView(projects: [], isLoading: false)
}
