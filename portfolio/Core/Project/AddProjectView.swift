//
//  AddProjectView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-02.
//

import SwiftUI
import Firebase
import PhotosUI

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
            .background {
                viewModel.backgroundImage.image
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
            }
        } else {
            VStack {
                header
                
                ScrollView {
                    
                   coverSection
                    
//                    videoSection
                    descriptionSection
                    
                    githubSection

                   photosSection
                    
                    Spacer(minLength: 50)
                    
                    toggleSection

                    

                }
                .onAppear {
    //                isPickerPresented.toggle()
                }
                .photosPicker(isPresented: $isPickerPresented, selection: $viewModel.selectedImage, matching: .any(of: [.images, .not(.videos)]))
                
                
                BackgroundPickerView(selectedImage: $viewModel.backgroundImage)

            }
            .background {
                viewModel.backgroundImage.image
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
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
        tabIndex = 0
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
                if let image = viewModel.projectImage {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(.rect(cornerRadius: 10))
                    Text("")
                           .font(.caption2)
                } else {
//                    Image(systemName: "info.circle")
                    Image("logo")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .clipShape(.rect(cornerRadius: 10))
                        .foregroundColor(Color(.systemGray4))
                    Text("100x100 pixels")
                           .font(.caption2)
                }
             
            }
            .onTapGesture {
                isPickerPresented.toggle()
            }
//            .padding(4)
            
            TextField("Enter your project title...", text: $viewModel.projectTitle, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                
        }
        .padding(.horizontal)
        .padding(.top)
    }
    
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
                    Text(viewModel.selectionImages.isEmpty ? "Select Images" : "Images Selected")
                        .font(.title)
                        .frame(width: 200, height: 50)
                        .background(viewModel.selectionImages.isEmpty ? Color.blue.gradient : Color.green.gradient)
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
    
    var githubSection: some View {
        TextField("Enter your project GitHub Link...", text: $viewModel.github, axis: .vertical)
            .textFieldStyle(.roundedBorder)
            .padding()
    }
    
    var toggleSection: some View {
        Toggle(isOn: $viewModel.isPublic, label: {
            if viewModel.isPublic {
                HStack {
                    Text("Your project is Public")
                        .font(.subheadline)
                        .padding(4)
                        .background(.thinMaterial)
                        .clipShape(.rect(cornerRadius: 8))
                    Spacer()
                    Image(systemName: "text.book.closed")
                        .imageScale(.large)
                        .padding(4)
                        .background(.thinMaterial)
                        .clipShape(.rect(cornerRadius: 8))
                }
            } else {
                HStack {
                    Text("Your project is Private")
                        .font(.subheadline)
                        .padding(4)
                        .background(.thinMaterial)
                        .clipShape(.rect(cornerRadius: 8))
                    Spacer()
                    Image(systemName: "lock")
                        .imageScale(.large)
                        .padding(4)
                        .background(.thinMaterial)
                        .clipShape(.rect(cornerRadius: 8))
                }
            }
        })
        .animation(.easeOut, value: viewModel.isPublic)
        .padding(.horizontal)
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
                        .background(viewModel.selectedVideo == nil ? Color.blue.gradient : Color.green.gradient)
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
