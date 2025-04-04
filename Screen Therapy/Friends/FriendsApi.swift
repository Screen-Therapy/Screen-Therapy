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
        let userId = KeychainItem.currentUserIdentifier() ?? Auth.auth().currentUser?.uid

        guard let userId = userId else {
            print("❌ No user ID found (Apple or Firebase)")
            completion(nil, nil)
            return
        }

        let urlString = API.Users.getUserById(userId)
        print("🌐 Fetching user details from: \(urlString)")

        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL: \(urlString)")
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
                    print("✅ User fetched: \(username), code: \(friendCode)")
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

    func fetchFriends(completion: @escaping ([Friend]) -> Void) {
        let userId = KeychainItem.currentUserIdentifier() ?? Auth.auth().currentUser?.uid
        guard let userId = userId else {
            print("❌ No userId found for fetchFriends")
            completion([])
            return
        }

        let urlString = "\(API.Friends.list)?userId=\(userId)"
        print("🌐 Fetching friends from: \(urlString)")

        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL: \(urlString)")
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                print("❌ Error fetching friends: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
                return
            }

            do {
                let decoded = try JSONDecoder().decode([Friend].self, from: data)
                print("✅ Friends fetched: \(decoded.count) found")
                completion(decoded)
            } catch {
                print("❌ JSON decode error: \(error)")
                completion([])
            }
        }.resume()
    }

    func addFriend(friendCode: String, completion: @escaping (Bool) -> Void) {
        let userId = KeychainItem.currentUserIdentifier() ?? Auth.auth().currentUser?.uid
        guard let userId = userId else {
            print("❌ No userId found for addFriend")
            completion(false)
            return
        }


        let urlString = API.Friends.addFriend
        print("📤 Sending add friend request to: \(urlString) with code: \(friendCode)")

        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL: \(urlString)")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = ["userId": userId, "friendCode": friendCode]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Add friend error: \(error)")
                completion(false)
                return
            }

            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            print("📬 Add friend response code: \(statusCode)")
            completion(statusCode == 200)
        }.resume()
    }
}
