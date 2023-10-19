//
//  AddProjectViewModel.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-18.
//

import SwiftUI
import Firebase
import PhotosUI
import Combine

@MainActor
class AddProjectViewModel: ObservableObject {
    @Published var selectedImage: PhotosPickerItem? {
        didSet { Task { await loadImage(from: selectedImage) } }
    }
    @Published var projectImage: Image?
    @Published var projectTitle: String = ""
    @Published var description: String = ""
    @Published var github: String = ""
    @Published var selectionImages: [UIImage] = []
    @Published var maxSelection: [PhotosPickerItem] = []
    @Published var selectedVideo: PhotosPickerItem?
    @Published var uploadText: String = ""
    @Published var uploadedVideoUrl: String?
    @Published var uploadedCoverImageUrl: String?
    @Published var backgroundImage: BackgroundImages = .bg3
    @Published var isPublic: Bool = true
    private var uiImage: UIImage?
    @Published var userSession: User?
    var subscriptions = Set<AnyCancellable>()
    init() {
        setupSubscribers()
    }
    
    private func setupSubscribers() {
        AuthenticationManager.shared.$userSession.sink { userSession in
            self.userSession = userSession
        }
        .store(in: &subscriptions)
    }
    
    func loadImage(from item: PhotosPickerItem?) async {
        guard let item = item else { return }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.projectImage = Image(uiImage: uiImage)
    }
    
    func uploadVideo(projectRef: String) async throws -> String? {
        guard let item = selectedVideo else { return nil }
        guard let videoData = try await item.loadTransferable(type: Data.self) else { return nil }
        guard let videoUrl = try await StorageManager.uploadVideo(data: videoData) else { return nil }
        
        try await FirestoreManager.shared.updateProjectVideo(projectId: projectRef, videoUrl: videoUrl)
        print("Video uploaded and firebase updated")
        return videoUrl
    }
    
    func uploadProject() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let projectRef = Firestore.firestore().collection(FirestorePath.projects.rawValue).document()
        
        if let uiImage  {
            uploadText = "Uploading Cover Image"
            uploadedCoverImageUrl = try await StorageManager.uploadImage(image: uiImage, savePath: .projects)
        }
        uploadText = "Uploading Video"
        if selectedVideo != nil {
            uploadedVideoUrl = try await uploadVideo(projectRef: projectRef.documentID) ?? ""
        }
        uploadText = "Uploading Detail Images"
        var detailImages: [String] = []
        for image in selectionImages {
            guard let detailImageUrl = try await StorageManager.uploadImage(image: image, savePath: .projects) else { return }
            detailImages.append(detailImageUrl)
        }
        let project = Project(id: projectRef.documentID, ownerUid: uid, projectTitle: projectTitle, description: description, likes: [], coverImageURL: uploadedCoverImageUrl, detailImageUrls: detailImages, backgroundImage: backgroundImage.rawValue, timeStamp: Timestamp(), videoUrl: uploadedVideoUrl, github: github, isPublic: isPublic)
        guard let encodedProject = try? Firestore.Encoder().encode(project) else { return }
        try await projectRef.setData(encodedProject)
        uploadText = ""
    }
    
    func clearProjectData() {
        maxSelection = []
        selectionImages = []
        description = ""
        projectTitle = ""
        selectedImage = nil
        projectImage = nil
    }
    
   
}
