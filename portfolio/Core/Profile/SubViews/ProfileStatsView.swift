//
//  ProfileStatsView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import SwiftUI

struct ProfileStatsView: View {
    let count: Int
    let title: String
    
    var body: some View {
        VStack {
            Text("\(count)")
                .font(.footnote)
                .fontWeight(.semibold)
            Text(title)
                .font(.footnote)
                .minimumScaleFactor(0.6)
                .lineLimit(1)
        }
        
    }
}

#Preview {
    ProfileStatsView(count: 13, title: "Posts")
}
