//
//  BackgroundPickerView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-09.
//

import SwiftUI


struct BackgroundPickerView: View {
    @Binding var selectedImage: BackgroundImages
        
    var body: some View {
        
        Menu {
            Picker("Image", selection: $selectedImage) {
                ForEach(BackgroundImages.allCases) { image in
                    HStack {
                        Text(image.rawValue)
                        image.image.resizable().scaledToFill()
                            .frame(width: 100, height: 200)
                    }
                }
            }
            .pickerStyle(.palette)
        } label: {
            Text("Background Image")
                .font(.callout)
                .padding(4)
                .background(.thinMaterial)
                .clipShape(.rect(cornerRadius: 8))
        }

    }
}

enum BackgroundImages: String, CaseIterable, Identifiable {
    case bg1, bg2, bg3
    var id: Self { self }
    var image: Image {
        switch self {
        case .bg1:
            Image(.bg1)
        case .bg2:
            Image(.bg2)
        case .bg3:
            Image(.bg3)
        }
    }
}

#Preview {
    BackgroundPickerView(selectedImage: .constant(.bg3))
}
