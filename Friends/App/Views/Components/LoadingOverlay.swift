//
//  LoadingOverlay.swift
//  Friends
//
//  Created by Ziqa on 29/07/26.
//

import SwiftUI

struct LoadingOverlay: View {
    var body: some View {
        ProgressView()
            .controlSize(.large)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .background(.gray.opacity(0.2))
    }
}

#Preview {
    LoadingOverlay()
}
