//
//  FriendListScreen.swift
//  Friends
//
//  Created by Ziqa on 01/08/26.
//

import SwiftUI

struct FriendListScreen: View {
    
    @State private var viewModel: FriendListViewModel
    
    private var friendCount = 10
    
    init(factory: ViewModelFactory) {
        _viewModel = State(initialValue: factory.makeFriendListViewModel())
    }
    
    var body: some View {
        List {
            ForEach(0..<friendCount, id: \.self) { i in
                HStack(spacing: 24) {
                    Circle()
                        .foregroundStyle(.gray.opacity(0.15))
                        .frame(maxWidth: 50, maxHeight: 50)
                    
                    Text("@username")
                        .font(.headline)
                        .padding(.vertical)
                    
                    Spacer(minLength: 0)
                    
                    Menu("", systemImage: "ellipsis") {
                        Button("Unfriend", systemImage: "person.slash.fill") {
                            
                        }
                        
                        Button("Block", systemImage: "nosign") {
                            
                        }
                    }
                }
                .listRowSeparator(.hidden)
            }
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .navigationTitle("Friends")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        FriendListScreen(factory: ViewModelFactory())
            .withPreviewEnvironments()
    }
}
