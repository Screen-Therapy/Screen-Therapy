//
//  AuthManager.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 3/20/25.
//

import AuthenticationServices
import Combine

class AuthManager: ObservableObject {
    @Published var isSignedIn: Bool = false

    init() {
        checkSignInStatus() // Automatically check sign-in on app launch
    }

    func checkSignInStatus() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        
        guard let userIdentifier = KeychainItem.currentUserIdentifier() else {
            DispatchQueue.main.async {
                self.isSignedIn = false
            }
            return
        }

        appleIDProvider.getCredentialState(forUserID: userIdentifier) { credentialState, error in
            DispatchQueue.main.async {
                switch credentialState {
                case .authorized:
                    self.isSignedIn = true  // ✅ User stays signed in
                case .revoked, .notFound:
                    self.isSignedIn = false // ❌ User must log in again
                    KeychainItem.deleteUserIdentifier()
                default:
                    self.isSignedIn = false
                }
            }
        }
    }
}
