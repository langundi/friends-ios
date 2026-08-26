//
//  SettingsScreen.swift
//  Friends
//
//  Created by Ziqa on 26/08/26.
//

import SwiftUI

struct SettingsScreen: View {
    @AppStorage(Constants.isUserLoggedIn) var isLoggedIn: Bool = true
    @Environment(AppRouter.self) var router
    @State private var viewModel: SettingsViewModel
    
    init(factory: ViewModelFactory) {
        _viewModel = State(initialValue: factory.makeSettingsViewModel())
    }
    
    var body: some View {
        Form {
            Section {
                Button {
                    
                } label: {
                    SettingRow(color: .blue, symbol: "person.fill", text: "Edit Profile")
                }
                .buttonStyle(.plain)
                
                Button {
                    
                } label: {
                    SettingRow(color: .blue, symbol: "key.fill", text: "Change Password")
                }
                .buttonStyle(.plain)
                
                Button {
                    
                } label: {
                    SettingRow(color: .red, symbol: "trash.fill", text: "Delete Account")
                }
                .buttonStyle(.plain)
            }
            
            Section {
                Button {
                    print("haha")
                    AlertManager.shared.showAlert(
                        title: "Sign Out",
                        message: "Are you sure you want to sign out?",
                        primaryAction: .init(title: "Sign Out", action: {
                            Task {
                                await viewModel.signOutUser()
                            }
                        }), secondaryAction: .init(title: "Cancel"))
                } label: {
                    SettingRow(color: .orange, symbol: "rectangle.portrait.and.arrow.forward", text: "Sign Out")
                }
                .buttonStyle(.plain)
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct SettingRow: View {
    let color: Color
    let symbol: String
    let text: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: symbol)
                .foregroundStyle(.white)
                .frame(width: 32, height: 32)
                .background(color.gradient)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            
            Text(text)
            
            Spacer(minLength: 0)
            
            Image(systemName: "chevron.right")
                .fontWeight(.medium)
        }
        .contentShape(.rect)
    }
}

#Preview {
    NavigationStack {
        SettingsScreen(factory: ViewModelFactory())
    }
    .withPreviewEnvironments()
}
