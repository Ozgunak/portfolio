//
//  CircularProfileImageView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import SwiftUI
import Kingfisher

enum CircularImageSize {
    case small
    case medium
    case large
    
    var dimentions: CGFloat {
        switch self {
        case .small:
            return 40
        case .medium:
            return 48
        case .large:
            return 80
        }
    }
}
struct CircularProfileImageView: View {
    let user: DBUser
    var size: CircularImageSize = .large
    var body: some View {
        if let imageURL = user.profileImageURL {
            KFImage(URL(string: imageURL))
                .resizable()
                .scaledToFill()
                .frame(width: size.dimentions, height: size.dimentions)
                .clipShape(Circle())
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: size.dimentions, height: size.dimentions)
                .clipShape(Circle())
                .foregroundColor(Color(.systemGray4))
        }
    }
}

#Preview {
    CircularProfileImageView(user: DBUser.MOCK_USER)
}
