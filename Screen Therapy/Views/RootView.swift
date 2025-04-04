//
//  RootView.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 3/20/25.
//


import SwiftUI

struct RootView: View {
    @EnvironmentObject var authManager: AuthManager // ✅ Use the one injected from App
    @EnvironmentObject var friendsCache: FriendsCache

    var body: some View {
        Group {
            if authManager.isSignedIn {
                ContentView()
            
            } else {
                WelcomeView()
            }
        }
    }
}
