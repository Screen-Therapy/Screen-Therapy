import AuthenticationServices

class SignInWithAppleHelper: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    let apiURL = "http://10.136.251.34:8080/"

    // Final result: .success means user is signed in and has a username
    func handleSignInResult(_ result: Result<ASAuthorization, Error>, completion: @escaping (Bool, Bool) -> Void) {
        switch result {
        case .success(let authorization):
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                let userId = appleIDCredential.user
                let email = appleIDCredential.email ?? "No email provided"

                KeychainItem.saveUserIdentifier(userId)

                print("User ID: \(userId)")
                print("Email: \(email)")

                // Step 1: Check if user exists
                checkIfUserExists(userId: userId) { exists in
                    if exists {
                        print("✅ Apple user exists. Checking for username...")
                        self.checkIfUsernameExists(userId: userId) { hasUsername in
                            completion(true, hasUsername)
                        }
                    } else {
                        print("🆕 New Apple user. Registering...")
                        self.registerUser(userId: userId, email: email) { success in
                            if success {
                                completion(true, false) // success, no username yet
                            } else {
                                completion(false, false)
                            }
                        }
                    }
                }
            } else {
                completion(false, false)
            }

        case .failure(let error):
            print("Apple Sign-In failed: \(error.localizedDescription)")
            completion(false, false)
        }
    }

    // Updated to new backend route
    func checkIfUserExists(userId: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(apiURL)apple/checkUser/\(userId)") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("❌ Error checking Apple user: \(error.localizedDescription)")
                completion(false)
                return
            }

            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            completion(status == 200)
        }.resume()
    }

    func checkIfUsernameExists(userId: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(apiURL)apple/checkUsername/\(userId)") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("❌ Error checking username: \(error.localizedDescription)")
                completion(false)
                return
            }

            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            completion(status == 200)
        }.resume()
    }

    func registerUser(userId: String, email: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(apiURL)apple/register") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let userData: [String: String] = [
            "userId": userId,
            "email": email
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: userData)
        } catch {
            print("❌ Error encoding Apple user data: \(error.localizedDescription)")
            completion(false)
            return
        }

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("❌ Error registering Apple user: \(error.localizedDescription)")
                completion(false)
                return
            }

            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            completion(status == 200)
        }.resume()
    }

    func saveUsername(userId: String, username: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(apiURL)apple/setUsername") else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = [
            "userId": userId,
            "username": username
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            print("❌ Error encoding saveUsername request: \(error)")
            completion(false)
            return
        }

        URLSession.shared.dataTask(with: request) { _, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("❌ Error saving username: \(error.localizedDescription)")
                    completion(false)
                    return
                }

                let status = (response as? HTTPURLResponse)?.statusCode ?? 0
                completion(status == 200)
            }
        }.resume()
    }

    
    // Required
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene,
              let window = windowScene.windows.first(where: { $0.isKeyWindow }) else {
            fatalError("No active window found for Apple Sign-In")
        }
        return window
    }
}
