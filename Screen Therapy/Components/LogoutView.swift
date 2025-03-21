//
//  LogoutView.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 3/20/25.
//


import SwiftUI

struct LogoutView: View {
    @EnvironmentObject var authManager: AuthManager // Access authentication state

    var body: some View {
        Button(action: {
            authManager.isSignedIn = false // ✅ Logs out and goes to WelcomeView
        }) {
            HStack {
                Spacer()
                Text("Log Out")
                    .foregroundColor(.red)
                    .bold()
                Spacer()
            }
        }
    }
}

#Preview {
    LogoutView().environmentObject(AuthManager()) // Pass mock AuthManager
}
