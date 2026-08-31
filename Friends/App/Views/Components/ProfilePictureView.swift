//
//  ProfilePictureView.swift
//  Friends
//
//  Created by Ziqa on 31/08/26.
//

import SwiftUI
import Kingfisher
import OSLog

struct ProfilePictureView: View {
    var imageURL: String?
    var size: ProfilePictureSize = .small
    
    private var fontSize: Font {
        switch size {
        case .xsmall:
            return .largeTitle
        case .small:
            return .system(size: 42)
        case .medium:
            return .system(size: 50)
        case .large:
            return .system(size: 68)
        case .xlarge:
            return .system(size: 84)
        }
    }
    
    var body: some View {
        Group {
            if let imageURL = imageURL {
                KFImage(URL(string: imageURL))
                    .placeholder{ LoadingOverlay() }
                    .resizable()
                    .retry(maxCount: 3, interval: .seconds(2))
                    .onFailure { error in
                        Logger.kingfisher.error("KF Error: \(error)")
                    }
                    .frame(maxWidth: size.rawValue, maxHeight: size.rawValue)
                    .aspectRatio(1.0, contentMode: .fit)
                    .clipShape(.circle)
            } else {
                Image(systemName: "person.fill")
                    .offset(y: 8)
                    .font(fontSize)
                    .foregroundStyle(.gray)
                    .frame(maxWidth: size.rawValue, maxHeight: size.rawValue)
                    .background(.bar)
                    .clipShape(.circle)
            }
        }
        .contentShape(.circle)
    }
}

#Preview {
    ProfilePictureView(size: .xlarge)
}
