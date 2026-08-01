//
//  ToolbarButtonStyle.swift
//  Friends
//
//  Created by Ziqa on 29/07/26.
//

import SwiftUI

struct ToolbarButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        if #available(iOS 26.0, *) {
            configuration.label
                .frame(minWidth: 44, minHeight: 44)
                .foregroundStyle(.primary)
                .font(.title3)
                .fontWeight(.medium)
                .glassEffect(.regular.interactive(true))
        } else {
            configuration.label
                .frame(minWidth: 48, minHeight: 48)
                .foregroundStyle(.blue)
                .font(.title2)
                .opacity(configuration.isPressed ? 0.4 : 1.0)
                .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
        }
            
    }
}
