//
//  AddProjectView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-02.
//

import SwiftUI
import Firebase
import PhotosUI
import AVKit

@MainActor
class AddProjectViewModel: ObservableObject {
    @Published var selectedImage: PhotosPickerItem? {
        didSet { Task { await loadImage(from: selectedImage) } }
    }
    @Published var projectImage: Image?
    @Published var projectTitle: String = ""
    @Published var description: String = ""
    @Published var selectionImages: [UIImage] = []
    @Published var maxSelection: [PhotosPickerItem] = []
    @Published var selectedVideo: PhotosPickerItem?
    @Published var uploadText: String = ""
    @Published var uploadedVideoUrl: String?
    private var uiImage: UIImage?
    
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
        guard let uiImage else { return }
        uploadText = "Uploading Cover Image"
        let projectRef = Firestore.firestore().collection(FirestorePath.projects.rawValue).document()
        guard let imageUrl = try await StorageManager.uploadImage(image: uiImage, savePath: .projects) else { return }
        uploadText = "Uploading Video"
        if let selectedVideo {
            uploadedVideoUrl = try await uploadVideo(projectRef: projectRef.documentID) ?? ""
        }
        uploadText = "Uploading Detail Images"
        var detailImages: [String] = []
        for image in selectionImages {
            guard let detailImageUrl = try await StorageManager.uploadImage(image: image, savePath: .projects) else { return }
            detailImages.append(detailImageUrl)
        }
        let project = Project(id: projectRef.documentID, ownerUid: uid, projectTitle: projectTitle, description: description, likes: [], coverImageURL: imageUrl, detailImageUrls: detailImages, timeStamp: Timestamp(), videoUrl: uploadedVideoUrl)
        guard let encodedProject = try? Firestore.Encoder().encode(project) else { return }
        try await projectRef.setData(encodedProject)
        uploadText = ""
    }
}

struct AddProjectView: View {
    @State private var isLoading: Bool = false
    @State private var isPickerPresented: Bool = false
    @StateObject var viewModel = AddProjectViewModel()
    @Binding var tabIndex: Int
    
    var body: some View {
        if isLoading {
            VStack {
                ProgressView()
                    .imageScale(.large)
                    .padding(.bottom)
                Text(viewModel.uploadText)
                    .font(.headline)
                Text("Please wait")
                    .font(.subheadline)
            }
        } else {
            VStack {
                header
                
                ScrollView {
                    
                   coverSection
                    
                    videoSection
                    
                   photosSection
                    
                   descriptionSection
                    
                    Spacer()
                }
                .onAppear {
    //                isPickerPresented.toggle()
                }
            .photosPicker(isPresented: $isPickerPresented, selection: $viewModel.selectedImage, matching: .any(of: [.images, .not(.videos)]))
            }
        }   
    }
    
    private func clearProjectData() {
        viewModel.maxSelection = []
        viewModel.selectionImages = []
        viewModel.description = ""
        viewModel.projectTitle = ""
        viewModel.selectedImage = nil
        viewModel.projectImage = nil
//        tabIndex = 0
    }
}


extension AddProjectView {
    var header: some View {
        HStack {
            Button(role: .cancel) {
                clearProjectData()
                
            } label: {
                Text("Cancel")
            }
            
            Spacer()
            
            Text("New Project")
            
            Spacer()
            
            Button {
                Task {
                    isLoading = true
                    try await viewModel.uploadProject()
                    clearProjectData()
                    isLoading = false
                }
            } label: {
                Text("Upload")
            }
        }
        .padding(.horizontal)    }
    
    var coverSection: some View {
        HStack {
            VStack(spacing: 0) {
                OzProfileImageView(image: viewModel.projectImage, size: .xLarge)
             Text("Project Icon")
            }
            .onTapGesture {
                isPickerPresented.toggle()
            }
            .padding(4)
            .background(.thinMaterial)
            .clipShape(.rect(cornerRadius: 8))
            
            TextField("Enter your project title...", text: $viewModel.projectTitle, axis: .vertical)
                
        }
        .padding()    }
    
    var photosSection: some View {
        VStack {
            if viewModel.selectionImages.count > 0 {
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(viewModel.selectionImages, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .containerRelativeFrame(.horizontal)
                                .frame(height: 400)
                                .clipShape(.rect)
                        }
                    }
                    .scrollTargetLayout()
                }
                .contentMargins(16, for: .scrollContent)
                .scrollTargetBehavior(.viewAligned)
            } else {
                
            }
            PhotosPicker(selection: $viewModel.maxSelection, maxSelectionCount: 3, matching: .any(of: [.images, .not(.videos)])) {
                VStack {
                    if viewModel.selectionImages.isEmpty {
                        Image(systemName: "photo.circle")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                    }
                    Text("Select Images")
                        .font(.title)
                        .frame(width: 200, height: 50)
                        .background(.blue.gradient)
                        .foregroundStyle(.white)
                        .clipShape(.rect(cornerRadius: 15))
                }
            }
            .onChange(of: viewModel.maxSelection) { oldValue, newValue in
                Task {
                    viewModel.selectionImages = []
                    for value in newValue {
                        if let imageData = try? await value.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                            viewModel.selectionImages.append(image)
                        }
                    }
                }
            }
        }
    }
    
    var descriptionSection: some View {
        TextField("Enter your project description...", text: $viewModel.description, axis: .vertical)
            .textFieldStyle(.roundedBorder)
            .padding()

    }
    
    var videoSection: some View {
        VStack {
            PhotosPicker(selection: $viewModel.selectedVideo, matching: .any(of: [.videos, .not(.images)])) {
                VStack {
                    Image(systemName: "video.circle")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                    Text(viewModel.selectedVideo == nil ? "Add Your Video" : "Video Selected")
                        .font(.title)
                        .frame(width: 200, height: 50)
                        .background(.blue.gradient)
                        .foregroundStyle(.white)
                        .clipShape(.rect(cornerRadius: 15))
                }
            }
        }
    }
}

#Preview {
    AddProjectView(tabIndex: .constant(2))
}
