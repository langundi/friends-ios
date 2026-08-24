//
//  ImageView.swift
//  Friends
//
//  Created by Ziqa on 20/08/26.
//

import SwiftUI
import Kingfisher
import OSLog

struct ImageView: View {
    var imageURL: String
    
    var body: some View {
        KFImage(URL(string: imageURL))
            .placeholder{ LoadingOverlay() }
            .resizable()
            .retry(maxCount: 3, interval: .seconds(2))
            .onFailure { error in
                Logger.kingfisher.error("KF Error: \(error)")
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(1.0, contentMode: .fit)
    }
}
