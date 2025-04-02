//
//  FriendsApi.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 3/31/25.
//

import Foundation
import FirebaseAuth

class FriendsApi {
    static let shared = FriendsApi()

    func fetchUserDetails(completion: @escaping (String?, String?) -> Void) {
        // Prefer Apple ID if available
        let userId = KeychainItem.currentUserIdentifier() ?? Auth.auth().currentUser?.uid

        guard let userId = userId else {
            print("❌ No user ID found (Apple or Firebase)")
            completion(nil, nil)
            return
        }

        guard let url = URL(string: API.Users.getUserById(userId)) else {
            print("❌ Invalid URL")
            completion(nil, nil)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print("❌ Error fetching user data: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil, nil)
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let username = json["username"] as? String,
                   let friendCode = json["friendCode"] as? String {
                    completion(username, friendCode)
                } else {
                    print("⚠️ Response missing expected keys or not in expected format.")
                    completion(nil, nil)
                }
            } catch {
                print("❌ JSON parsing error: \(error.localizedDescription)")
                completion(nil, nil)
            }
        }.resume()
    }
}
