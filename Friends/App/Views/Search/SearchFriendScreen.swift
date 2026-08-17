//
//  SearchFriendScreen.swift
//  Friends
//
//  Created by Ziqa on 14/08/26.
//

import SwiftUI

struct SearchFriendScreen: View {
    @State private var viewModel: SearchViewModel
    @State private var searchText: String = ""
    
    init(factory: ViewModelFactory) {
        _viewModel = State(initialValue: factory.makeSearchViewModel())
    }
    
    var body: some View {
        Form {
            Section("Enter a username:") {
                HStack {
                    TextField("Username", text: $searchText)
                        .textInputAutocapitalization(.never)
                        .textContentType(.username)
                        .submitLabel(.search)
                        .onSubmit {
                            searchUsername()
                        }
                    
                    Button("Search") {
                        searchUsername()
                    }
                }
            }
            
            if let username = viewModel.user?.username {
                Section {
                    HStack(spacing: 24) {
                        Text(username)
                        
                        Spacer(minLength: 0)
                        
                        Button("Add friend") {
                            print("add friend pressed")
                        }
                    }
                }
            }
        }
        .navigationTitle("Find Friends")
        .navigationBarTitleDisplayMode(.inline)
        .overlay {
            if viewModel.isLoading {
                LoadingOverlay()
            }
        }
        .onDisappear {
            viewModel.clearResult()
        }
    }
    
    private func searchUsername() {
        Task {
            await viewModel.searchUsername(searchText: searchText)
        }
    }
}

#Preview {
    NavigationStack {
        SearchFriendScreen(factory: ViewModelFactory())
    }
}
