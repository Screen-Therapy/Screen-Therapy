//
//  AuthManager.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 3/20/25.
//

import AuthenticationServices
import Combine
import FirebaseAuth


class AuthManager: ObservableObject {
    @Published var isSignedIn: Bool = false

    init() {
        checkSignInStatus() // Automatically check sign-in on app launch
    }

    func checkSignInStatus() {
        if let user = Auth.auth().currentUser {
            // ✅ User is signed in with Firebase (email/password)
            print("✅ Firebase email user is already signed in: \(user.uid)")
            self.isSignedIn = true
            return
        }

        // 👇 Fallback to Apple Sign-In if no Firebase user is found
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        guard let userIdentifier = KeychainItem.currentUserIdentifier() else {
            self.isSignedIn = false
            return
        }

        appleIDProvider.getCredentialState(forUserID: userIdentifier) { credentialState, _ in
            DispatchQueue.main.async {
                switch credentialState {
                case .authorized:
                    self.isSignedIn = true
                case .revoked, .notFound:
                    self.isSignedIn = false
                    KeychainItem.deleteUserIdentifier()
                default:
                    self.isSignedIn = false
                }
            }
        }
    }

}
