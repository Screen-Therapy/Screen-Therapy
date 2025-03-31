import AuthenticationServices

class SignInWithAppleHelper: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    let apiURL = "http://10.20.0.24:8080/"

    func handleSignInResult(_ result: Result<ASAuthorization, Error>, completion: @escaping (Bool) -> Void) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                let userId = appleIDCredential.user
                let fullName = "\(appleIDCredential.fullName?.givenName ?? "") \(appleIDCredential.fullName?.familyName ?? "")"
                let email = appleIDCredential.email ?? "No email provided"

                // Save user ID to Keychain
                KeychainItem.saveUserIdentifier(userId)

                print("User ID: \(userId)")
                print("Full Name: \(fullName)")
                print("Email: \(email)")

                // 🔥 Step 1: Check if user exists in Firestore before registering
                checkIfUserExists(userId: userId) { exists in
                    if exists {
                        print("✅ User already exists. Proceeding with sign-in...")
                        completion(true)
                    } else {
                        print("🆕 User does not exist. Registering now...")
                        self.sendUserDataToBackend(userId: userId, fullName: fullName, email: email, completion: completion)
                    }
                }
            } else {
                completion(false)
            }
            
        case .failure(let error):
            print("Apple Sign-In failed: \(error.localizedDescription)")
            completion(false)
        }
    }

    // 🔍 Step 2: Check if the user exists in Firestore
    func checkIfUserExists(userId: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "\(apiURL)checkUser/\(userId)")! // 🔥 Use apiURL
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Error checking user: \(error.localizedDescription)")
                completion(false) // Assume user doesn't exist on failure
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid server response")
                completion(false)
                return
            }

            if httpResponse.statusCode == 200 {
                completion(true) // ✅ User exists
            } else {
                completion(false) // ❌ User does not exist
            }
        }

        task.resume()
    }

    // 🔥 Step 3: Register User in Backend if They Don't Exist
    func sendUserDataToBackend(userId: String, fullName: String, email: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "\(apiURL)registerUser")! // 🔥 Use apiURL
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let userData: [String: String] = [
            "userId": userId,
            "fullName": fullName,
            "email": email
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: userData, options: [])
        } catch {
            print("Error encoding user data: \(error.localizedDescription)")
            completion(false)
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Error sending user data: \(error.localizedDescription)")
                completion(false)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("❌ Server error: Invalid response")
                completion(false)
                return
            }

            print("✅ User successfully registered in the backend!")
            completion(true)
        }

        task.resume()
    }

    // Required function for ASAuthorizationControllerPresentationContextProviding
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
