//
//  SetProfilePictureSheet.swift
//  Friends
//
//  Created by Ziqa on 31/08/26.
//

import SwiftUI

struct SetProfilePictureSheet: View {
    @Environment(\.dismiss) var dismiss
    @State private var viewModel: EditProfileViewModel
    @State private var image: UIImage?
    @State private var pickerSource: PickerSource?
    @State private var isShowingImagePicker: Bool = false
    
    private var isImageTaken: Bool {
        image != nil
    }
    
    init(viewModel: EditProfileViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                if let image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                    
                    Spacer()
                } else {
                    ContentUnavailableView("", systemImage: "photo", description: Text("Take a picture or choose from library."))
                }
            }
            .padding()
            .navigationTitle("Set Profile Picture")
            .navigationBarTitleDisplayMode(.inline)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        Task {
                            await viewModel.setProfilePicture(image: image!) {
                                dismiss()
                            }
                        }
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.white)
                    }
                    .disabled(!isImageTaken)
                    .buttonStyle(.borderedProminent)
                }
            }
            .overlay(alignment: .bottomTrailing) {
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
                .transition(.opacity)
            }
            .overlay(alignment: .center) {
                if viewModel.isLoading {
                    LoadingOverlay()
                }
            }
            .fullScreenCover(item: $pickerSource) { picker in
                ImagePicker(selectedImage: $image, sourceType: picker.sourceType)
                    .ignoresSafeArea()
            }
        }
    }
}

#Preview {
    SetProfilePictureSheet(viewModel: EditProfileViewModel.mockVM)
}
