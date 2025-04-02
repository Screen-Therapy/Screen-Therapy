//
//  SignInWithEmailHelper.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 3/31/25.
//

import Foundation
import FirebaseAuth

class SignInWithEmailHelper {
    
    func registerUser(userId: String, username: String, email: String, completion: @escaping (Bool) -> Void) {
        print("📤 Attempting to register user: \(username), email: \(email), userId: \(userId)")

        guard let url = URL(string: API.Email.register) else {
            print("❌ Invalid URL")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let userData: [String: String] = [
            "userId": userId,
            "username": username,
            "email": email
        ]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: userData)
        } catch {
            print("❌ Error encoding user data: \(error.localizedDescription)")
            completion(false)
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
                completion(false)
                return
            }

            let status = (response as? HTTPURLResponse)?.statusCode ?? 0
            print("📬 Register response status code: \(status)")

            if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                print("📦 Backend response body: \(responseBody)")
            }

            completion(status == 200)
        }.resume()
    }

    func loginUser(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("❌ Firebase sign-in failed: \(error.localizedDescription)")
                completion(false)
                return
            }

            guard let userId = result?.user.uid else {
                completion(false)
                return
            }

            self.verifyUserInBackend(userId: userId, completion: completion)
        }
    }

    private func verifyUserInBackend(userId: String, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: API.Email.login) else {
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: String] = ["userId": userId]

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body)
        } catch {
            completion(false)
            return
        }

        URLSession.shared.dataTask(with: request) { _, response, error in
            if let error = error {
                print("❌ Backend verification failed: \(error.localizedDescription)")
                completion(false)
                return
            }

            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            completion(statusCode == 200)
        }.resume()
    }
}
