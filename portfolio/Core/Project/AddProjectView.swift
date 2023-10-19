//
//  AddProjectView.swift
//  portfolio
//
//  Created by özgün aksoy on 2023-10-02.
//

import SwiftUI
import PhotosUI

struct AddProjectView: View {
    @State private var isLoading: Bool = false
    @State private var isPickerPresented: Bool = false
    @StateObject var viewModel = AddProjectViewModel()
    @Binding var tabIndex: Int
    @State private var showSignInView: Bool = false
    
    var body: some View {
        VStack {
            if viewModel.userSession?.isAnonymous == true {
                SignUpPromoteView()
            } else {
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
                        .photosPicker(isPresented: $isPickerPresented, selection: $viewModel.selectedImage, matching: .any(of: [.images, .not(.videos)]))
                        
                        
                        BackgroundPickerView(selectedImage: $viewModel.backgroundImage)
                        
                    }
                    .background {
                        viewModel.backgroundImage.image
                            .resizable()
                            .scaledToFill()
                            .ignoresSafeArea()
                        //                    .overlay(
                        //                        LinearGradient(gradient: Gradient(colors: [.black.opacity(0.2), .clear, .black.opacity(0.2)]),startPoint: .top, endPoint: .bottom)
                        //                    )
                        // MARK: Overlay for images
                    }
                }
            }
        }
        .sheet(isPresented: $showSignInView, content: {
            NavigationStack {
                LoginView(showSignInView: $showSignInView)
            }
        })
    }
}


extension AddProjectView {
    var header: some View {
        HStack {
            Button(role: .cancel) {
                viewModel.clearProjectData()
                tabIndex = 0
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
                    viewModel.clearProjectData()
                    tabIndex = 0
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
                            ZStack {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .containerRelativeFrame(.horizontal)
                                    .frame(height: 400)
                                    .clipShape(.rect)
                                    .blur(radius: 106.0, opaque: true)
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .containerRelativeFrame(.horizontal)
                                    .frame(height: 400)
                                    .clipShape(.rect)
                                
                            }
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
