//
//  EditProfileViewModel.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-01.
//

import SwiftUI
import PhotosUI

@MainActor
class EditProfileViewModel: ObservableObject {
    @Published var user: DBUser
    @Published var selectedImage: PhotosPickerItem? {
        didSet { Task { await loadImage(from: selectedImage) } }
    }
    @Published var profileImage: Image?
    @Published var fullname: String = ""
    @Published var title: String = ""
    @Published var github: String = ""
    @Published var linkedin: String = ""
    private var uiImage: UIImage?
    
    init(user: DBUser) {
        self.user = user
        
        if let fullName = user.fullName {
            self.fullname = fullName
        }
        if let title = user.title {
            self.title = title
        }
        if let github = user.github {
            self.github = github
        }
        if let linkedin = user.linkedin {
            self.linkedin = linkedin
        }
    }
    
    func loadImage(from item: PhotosPickerItem?) async {
        guard let item = item else { return }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.profileImage = Image(uiImage: uiImage)
        
    }
    
    func updateUserData() async throws {
        
        var data: [String: Any] = [:]
        
        if let uiImage {
            let profileString = try? await StorageManager.uploadImage(image: uiImage, savePath: .users)
            data["profileImageURL"] = profileString
            print(data)
            self.profileImage = Image(uiImage: uiImage)
        }
        
        if !fullname.isEmpty && user.fullName != fullname {
            data["fullName"] = fullname
            self.fullname = fullname
        }
        if !title.isEmpty && user.title != title {
            data["title"] = title
            self.title = title
        }
        if !github.isEmpty && user.github != github {
            data["github"] = github
            self.github = github
        }
        if !linkedin.isEmpty && user.linkedin != linkedin {
            data["linkedin"] = linkedin
            self.linkedin = linkedin
        }
        
        if !data.isEmpty {
            print(data)
            try await FirestoreManager.shared.updateUserInfo(userId: user.id, data: data)
            print("updated firestore with new profile data")
        }
        
    }
}
