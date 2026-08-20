//
//  Extensions.swift
//  Friends
//
//  Created by Ziqa on 28/07/26.
//

import SwiftUI

extension View {
    @ViewBuilder
    func removeRowInset() -> some View {
        self.listRowBackground(Color.clear)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .gesture(DragGesture(minimumDistance: 0))
    }
    
    // MARK: - Previews
    
    @ViewBuilder
    func withPreviewEnvironments() -> some View {
        let alert = AlertManager.shared
        let router = AppRouter()
        
        self.environment(router)
            .environment(alert)
    }
}
