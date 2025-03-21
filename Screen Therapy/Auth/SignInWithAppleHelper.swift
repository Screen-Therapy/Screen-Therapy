import AuthenticationServices

class SignInWithAppleHelper: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func handleSignInResult(_ result: Result<ASAuthorization, Error>, completion: @escaping (Bool) -> Void) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                let userId = appleIDCredential.user
                let fullName = appleIDCredential.fullName
                let email = appleIDCredential.email
                
                // Save user ID to Keychain
                KeychainItem.saveUserIdentifier(userId)

                print("User ID: \(userId)")
                print("Full Name: \(fullName?.givenName ?? "") \(fullName?.familyName ?? "")")
                print("Email: \(email ?? "No email provided")")

                completion(true) // ✅ Notify success

            } else {
                completion(false)
            }
            
        case .failure(let error):
            print("Apple Sign-In failed: \(error.localizedDescription)")
            completion(false) // Notify failure
        }
    }

    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow })
        else {
            fatalError("No active window found for Apple Sign-In")
        }
        return window
    }
}
