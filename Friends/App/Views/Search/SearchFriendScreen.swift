//
//  SearchFriendScreen.swift
//  Friends
//
//  Created by Ziqa on 14/08/26.
//

import SwiftUI

struct SearchFriendScreen: View {
    @State private var searchText: String = ""
    
    init(factory: ViewModelFactory) {
        
    }
    
    var body: some View {
        Form {
            Section("Enter a username:") {
                HStack {
                    TextField("Username", text: $searchText)
                    
                    Button("Search") {
                        
                    }
                }
            }
            
            Section {
                HStack(spacing: 24) {
                    Text("@username")
                    
                    Spacer(minLength: 0)
                    
                    Button("Add friend") {
                        // Add user or unfriend
                    }
                }
            }
        }
        .navigationTitle("Find Friends")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SearchFriendScreen(factory: ViewModelFactory())
    }
}
