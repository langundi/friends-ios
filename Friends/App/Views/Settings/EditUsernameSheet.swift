//
//  EditUsernameSheet.swift
//  Friends
//
//  Created by Ziqa on 26/08/26.
//

import SwiftUI

struct EditUsernameSheet: View {
    @Environment(\.dismiss) var dismiss
    @State var value: String
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Username", text: $value)
                    .autocorrectionDisabled()
                    .textCase(.lowercase)
                    .textContentType(.username)
            }
            .navigationTitle("Username")
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
    NavigationStack {
        EditUsernameSheet(value: "dorami")
    }
}
