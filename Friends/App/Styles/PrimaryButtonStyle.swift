//
//  PrimaryButtonStyle.swift
//  Friends
//
//  Created by Ziqa on 29/07/26.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, maxHeight: 45, alignment: .center)
            .foregroundStyle(.white)
            .background(.blue)
            .clipShape(.capsule)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(.snappy(duration: 0.15), value: configuration.isPressed)
            
    }
}

#Preview {
    VStack{
        Button("Button") { }
            .buttonStyle(PrimaryButtonStyle())
    }
    .padding()
}
