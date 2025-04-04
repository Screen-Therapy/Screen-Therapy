//
//  LogoutView.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 3/20/25.
//


import SwiftUI
import FirebaseAuth

struct LogoutButton: View {
    @EnvironmentObject var authManager: AuthManager
    @EnvironmentObject var friendsCache: FriendsCache
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        Button(action: {
            print("🚪 Logging out...")

            // ❌ Firebase sign-out
            do {
                try Auth.auth().signOut()
                print("✅ Firebase user signed out.")
            } catch {
                print("❌ Failed to sign out of Firebase: \(error)")
            }

            // ❌ Clear Keychain
            KeychainItem.deleteUserIdentifier()

            // ❌ Clear UserDefaults
            UserDefaults.standard.removeObject(forKey: "username")
            UserDefaults.standard.removeObject(forKey: "friendCode")

            // ❌ Clear cached friends
            print("🧼 Clearing friend cache...")
            friendsCache.clearCache()

            // ✅ Update auth state
            authManager.isSignedIn = false
        }) {
            HStack(spacing: 6) {
                Image(systemName: "arrow.backward.circle.fill")
                    .foregroundColor(.white)

                Text("Log Out")
                    .foregroundColor(.white)
                    .bold()

                Spacer()
            }
            .padding()
            .background(Color("SecondaryPurple"))
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    LogoutButton()
        .environmentObject(AuthManager())
        .environmentObject(FriendsCache())
}
