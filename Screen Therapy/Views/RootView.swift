//
//  RootView.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 3/20/25.
//


import SwiftUI

struct RootView: View {
    @StateObject private var authManager = AuthManager() // Tracks authentication state

    var body: some View {
        Group {
            if authManager.isSignedIn {
                ContentView().environmentObject(authManager) // ✅ Shows settings when signed in
            } else {
                WelcomeView().environmentObject(authManager) // ✅ Redirects to login
            }
        }
    }
}
