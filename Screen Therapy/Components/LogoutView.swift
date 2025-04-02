//
//  LogoutView.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 3/20/25.
//


import SwiftUI

struct LogoutView: View {
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        Button(action: {
            // ❌ Clear Keychain
            KeychainItem.deleteUserIdentifier()

            // ❌ Clear UserDefaults
            UserDefaults.standard.removeObject(forKey: "username")
            UserDefaults.standard.removeObject(forKey: "friendCode")

            // ✅ Update auth state
            authManager.isSignedIn = false
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
