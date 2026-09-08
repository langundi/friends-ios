//
//  SearchFriendScreen.swift
//  Friends
//
//  Created by Ziqa on 14/08/26.
//

import SwiftUI

struct SearchFriendScreen: View {
    @Environment(AppRouter.self) var router
    @State private var viewModel: SearchViewModel
    @State private var searchText: String = ""
    @FocusState private var isTextFieldActive: Bool
    
    init(factory: ViewModelFactory, username: String? = nil) {
        _viewModel = State(initialValue: factory.makeSearchViewModel())
        
        if let username {
            _searchText = State(initialValue: username)
        }
    }
    
    var body: some View {
        Form {
            Section {
                TextField("Enter your friend's username", text: $searchText)
                    .textInputAutocapitalization(.never)
                    .textContentType(.username)
                    .submitLabel(.search)
                    .focused($isTextFieldActive)
                    .onSubmit {
                        isTextFieldActive = false
                        searchUsername()
                    }
            }
            
            Section {
                Button("Search", systemImage: "magnifyingglass") {
                    isTextFieldActive = false
                    searchUsername()
                }
                .buttonStyle(PrimaryButtonStyle())
                .disabled(searchText.isEmpty)
            }
            .listSectionSpacing(12)
            .removeRowInset()
            
            if let user = viewModel.searchedUser {
                Section("") {
                    HStack(spacing: 24) {
                        Text("@\(user.username)")
                        
                        Spacer(minLength: 0)
                        
                        switch viewModel.status {
                        case .notAdded:
                            Button {
                                Task {
                                    await viewModel.sendFriendRequest(receiverID: user.id) {
                                        viewModel.status = .sent
                                    }
                                }
                            } label: {
                                HStack {
                                    Image(systemName: "plus")
                                        .fontWeight(.medium)
                                    
                                    Text("Add")
                                        .fontWeight(.semibold)
                                }
                                .foregroundStyle(.blue)
                            }
                        case .sent:
                            Text("Pending").italic()
                        case .received:
                            Button {
                                router.push(to: .friendRequest)
                            } label: {
                                HStack {
                                    Text("Sent you a request")
                                    
                                    Image(systemName: "chevron.right")
                                        .fontWeight(.medium)
                                }
                                .foregroundStyle(.blue)
                            }
                        case .friends:
                            Text("Friends with you").italic()
                        case .none:
                            EmptyView()
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
        guard !searchText.isEmpty else {
            return
        }
        
        Task {
            await viewModel.searchUsername(searchText: searchText)
            
            if let userID = viewModel.searchedUser?.id {
                await viewModel.checkFriendshipStatus(userID: userID)
            }
        }
    }
}

#Preview {
    NavigationStack {
        SearchFriendScreen(factory: ViewModelFactory())
    }
}
