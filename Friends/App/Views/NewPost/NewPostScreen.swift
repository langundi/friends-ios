//
//  NewPostScreen.swift
//  Friends
//
//  Created by Ziqa on 12/08/26.
//

import SwiftUI

struct NewPostScreen: View {
    @Environment(AppRouter.self) var router
    @State private var viewModel: NewPostViewModel
    @State private var timelineViewModel: TimelineViewModel
    @State private var image: UIImage?
    @State private var caption: String = ""
    @State private var isShowingImagePicker: Bool = false
    @State private var pickerSource: PickerSource?
    @FocusState private var isTextFieldFocused
    
    init(factory: ViewModelFactory) {
        _viewModel = State(initialValue: factory.makeNewPostViewModel())
        
        timelineViewModel = factory.timelineViewModel
    }
    
    private var isImageTaken: Bool {
        image != nil
    }
    
    private var isCharacterLimit: Bool {
        caption.count == 60
    }
    
    var body: some View {
        VStack {
            if let image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                
                TextField("Caption", text: $caption, axis: .vertical)
                    .focused($isTextFieldFocused)
                    .autocorrectionDisabled(true)
                    .submitLabel(.done)
                    .frame(minHeight: 50, alignment: .top)
                    .padding(.top)
                    .onChange(of: caption) { _, newValue in
                        if newValue.hasSuffix("\n") {
                            caption = String(newValue.dropLast())
                            isTextFieldFocused = false
                        } else {
                            caption = String(newValue.prefix(60))
                        }
                    }
                
                Text("Maximum character limit reached.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(isCharacterLimit ? .red : .clear)
                
                Spacer(minLength: 0)
            } else {
                ContentUnavailableView("", systemImage: "photo", description: Text("Take a picture or choose from library."))
            }
        }
        .padding()
        .navigationTitle("New Post")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(alignment: .bottom) {
            VStack(alignment: .trailing, spacing: 16) {
                Button {
                    pickerSource = .library
                } label: {
                    Label("Library", systemImage: "photo.fill")
                        .padding(.horizontal)
                }
                .buttonStyle(ToolbarButtonStyle())
                
                Button {
                    pickerSource = .camera
                } label: {
                    Label("Camera", systemImage: "camera.fill")
                        .padding(.horizontal)
                }
                .buttonStyle(ToolbarButtonStyle())
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding()
        }
        .overlay(alignment: .center) {
            if viewModel.isLoading {
                LoadingOverlay()
            }
        }
        .toolbarVisibility(.hidden, for: .tabBar)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task {
                        await viewModel.uploadNewPost(image: image!, caption: caption) {
                            timelineViewModel.hasLoaded = false
                            router.pop()
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "checkmark")
                            .font(.caption)
                            .fontWeight(.medium)
                        
                        Text("Post")
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(isImageTaken ? .blue : .gray)
                }
                .allowsHitTesting(isImageTaken)
            }
        }
        .fullScreenCover(item: $pickerSource) { picker in
            ImagePicker(selectedImage: $image, sourceType: picker.sourceType)
                .ignoresSafeArea()
        }
    }
    
    func refreshAndPop() {
        Task {
            await timelineViewModel.refreshTimeline()
            router.pop()
        }
    }
}

/// A delegate enum for UIImagePickerController source type to fix SwiftUI picker bug.
private enum PickerSource: Identifiable {
    case camera
    case library
    
    var id: Self { self }
    
    var sourceType: UIImagePickerController.SourceType {
        switch self {
        case .camera: .camera
        case .library: .photoLibrary
        }
    }
}

#Preview {
    NavigationStack {
        NewPostScreen(factory: ViewModelFactory())
    }
    .withPreviewEnvironments()
}
