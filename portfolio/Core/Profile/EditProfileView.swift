//
//  EditProfileView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject var viewModel: EditProfileViewModel
    @State private var isLoading: Bool = false

    init(user: DBUser) {
        self._viewModel = StateObject(wrappedValue: EditProfileViewModel(user: user))
    }
    var body: some View {
        ZStack {
            if isLoading {
                ProgressView()
            }
            
            VStack {
                HStack{
                    Button("Cancel") {
                        dismiss()
                    }
                    Spacer()
                    Text("Edit Profile")
                        .font(.title3)
                        .fontWeight(.semibold)
                    Spacer()
                    Button(action: {
                        Task {
                            isLoading = true
                            try await viewModel.updateUserData()
                            isLoading = false
                            dismiss()
                        }
                    }, label: {
                        Text("Done")
                            .fontWeight(.semibold)
                    })
                }
                .padding(.horizontal)
                PhotosPicker(selection: $viewModel.selectedImage) {
                    VStack {
                        if let image = viewModel.profileImage {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .clipShape(.circle)
                        
                        } else {
                            OzProfileImageView(urlString: viewModel.user.profileImageURL)
                        }
                    
                    Text("Edit Profile Picture")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    }
                }
                
                Divider()
                VStack {
                    EditProfileRowView(title: "Full Name", placeHolder: "Enter your name", text: $viewModel.fullname)
                    EditProfileRowView(title: "Title", placeHolder: "Enter your title", text: $viewModel.title)
                    EditProfileRowView(title: "Bio", placeHolder: "Enter your bio", text: $viewModel.bio)
                    EditProfileRowView(title: "Github", placeHolder: "Enter your Github link", text: $viewModel.github, isLinkString: true)
                    EditProfileRowView(title: "LinkedIn", placeHolder: "Enter your LinkedIn link", text: $viewModel.linkedin, isLinkString: true)

                }
                .padding(.horizontal)
                
                
                Spacer()
                
                BackgroundPickerView(selectedImage: $viewModel.backgroundImage)
            }
            
        }
        .background {
            viewModel.backgroundImage.image
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
        }
    }
}

struct EditProfileRowView: View {
    let title: String
    let placeHolder: String
    @Binding var text: String
    let isLinkString: Bool

    
    init(title: String, placeHolder: String, text: Binding<String>, isLinkString: Bool = false) {
        self.title = title
        self.placeHolder = placeHolder
        self._text = text
        self.isLinkString = isLinkString
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                Divider().hidden()
            }
            .frame(width: 100, alignment: .leading)
            
            VStack {
                TextField(placeHolder, text: $text, axis: .vertical)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    .textContentType(isLinkString ? .emailAddress : .givenName)
                Divider()
            }
        }
        .font(.subheadline)
    }
}

#Preview {
    EditProfileView(user: DBUser.MOCK_USER)
}
