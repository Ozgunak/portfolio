//
//  AddProject.swift
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
    private var uiImage: UIImage?
    
    func loadImage(from item: PhotosPickerItem?) async {
        guard let item = item else { return }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.projectImage = Image(uiImage: uiImage)
    }
    
    func uploadProject() async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let uiImage else { return }
        
        let projectRef = Firestore.firestore().collection(StoragePath.project.stringValue).document()
        guard let imageUrl = try await StorageManager.uploadImage(image: uiImage, savePath: .project) else { return }
        let project = Project(id: projectRef.documentID, ownerUid: uid, projectTitle: projectTitle, description: description, likes: [], imageURL: imageUrl, timeStamp: Timestamp())
        guard let encodedProject = try? Firestore.Encoder().encode(project) else { return }
        try await projectRef.setData(encodedProject)
    }
}

struct AddProject: View {
    @State private var isLoading: Bool = false
    @State private var isPickerPresented: Bool = false
    @State private var maxSelection: [PhotosPickerItem] = []
    @State private var selectionImages: [UIImage] = []
    @StateObject var viewModel = AddProjectViewModel()
    @Binding var tabIndex: Int
    
    var body: some View {
        VStack {
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
            .padding(.horizontal)
            
            ScrollView {
                
                
                HStack {
                    VStack(spacing: 0) {
                        if let image = viewModel.projectImage {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(.rect(cornerRadius: 15))
                        } else {
                            Image(systemName: "photo.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                                .clipped()
                                
                        }
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
                .padding()
                
                if selectionImages.count > 0 {
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(selectionImages, id: \.self) { image in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .containerRelativeFrame(.horizontal)
                                    .frame(maxHeight: 400)
                                    .clipShape(.rect)
                            }
                        }
                        .scrollTargetLayout()
                    }
                    .contentMargins(16, for: .scrollContent)
                    .scrollTargetBehavior(.viewAligned)
                } else {
                    
                }
                PhotosPicker(selection: $maxSelection, maxSelectionCount: 3, matching: .any(of: [.images, .not(.videos)])) {
                    VStack {
                        if selectionImages.isEmpty {
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
                .onChange(of: maxSelection) { oldValue, newValue in
                    Task {
                        selectionImages = []
                        for value in newValue {
                            if let imageData = try? await value.loadTransferable(type: Data.self), let image = UIImage(data: imageData) {
                                selectionImages.append(image)
                            }
                        }
                    }
                }
                
                TextField("Enter your project description...", text: $viewModel.description, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .padding()

                
                Spacer()
            }
            .onAppear {
    //            isPickerPresented.toggle()
            }
        .photosPicker(isPresented: $isPickerPresented, selection: $viewModel.selectedImage, matching: .any(of: [.images, .not(.videos)]))
        }   
    }
    
    private func clearProjectData() {
        viewModel.description = ""
        viewModel.projectTitle = ""
        viewModel.selectedImage = nil
        viewModel.projectImage = nil
        tabIndex = 0
    }
}

#Preview {
    AddProject(tabIndex: .constant(2))
}
