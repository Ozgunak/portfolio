//
//  OzProfileImageView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import SwiftUI
import Kingfisher

enum OzProfileImageSize {
    case small
    case medium
    case large
    case xLarge
    
    var dimentions: CGFloat {
        switch self {
        case .small:
            return 40
        case .medium:
            return 48
        case .large:
            return 80
        case .xLarge:
            return 100
        }
    }
}
struct OzProfileImageView: View {
    let urlString: String?
    let image: Image?
    
    init(urlString: String?, size: OzProfileImageSize = .large) {
        self.urlString = urlString
        self.image = nil
        self.size = size
    }
    init(image: Image?, size: OzProfileImageSize = .large) {
        self.image = image
        self.size = size
        self.urlString = nil
    }
    
    var size: OzProfileImageSize = .large
    var body: some View {
        if let imageURL = urlString {
            KFImage(URL(string: imageURL))
                .resizable()
                .scaledToFill()
                .frame(width: size.dimentions, height: size.dimentions)
                .clipShape(.rect(cornerRadius: 10))
        } else if let image {
            image
                .resizable()
                .scaledToFill()
                .frame(width: size.dimentions, height: size.dimentions)
                .clipShape(.rect(cornerRadius: 10))
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: size.dimentions, height: size.dimentions)
                .clipShape(.rect(cornerRadius: 10))
                .foregroundColor(Color(.systemGray4))
        }
    }
}

#Preview {
    OzProfileImageView(urlString: DBUser.MOCK_USER.profileImageURL)
}
