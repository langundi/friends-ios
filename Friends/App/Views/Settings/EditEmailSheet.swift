//
//  EditEmailSheet.swift
//  Friends
//
//  Created by Ziqa on 26/08/26.
//

import SwiftUI

struct EditEmailSheet: View {
    @Environment(\.dismiss) var dismiss
    @State var value: String
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Email", text: $value)
                    .autocorrectionDisabled()
                    .textCase(.lowercase)
                    .textContentType(.username)
            }
            .navigationTitle("Email")
            .navigationBarTitleDisplayMode(.inline)
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
                        dismiss()
                    } label: {
                        Image(systemName: "checkmark")
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

#Preview {
    EditEmailSheet(value: "dorami@mail.com")
}
