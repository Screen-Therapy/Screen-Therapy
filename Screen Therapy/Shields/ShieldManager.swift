//
//  ShieldManager.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 4/5/25.
//

import Foundation



class ShieldManager {
    static func createShield(_ shield: ShieldRequest, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: API.Shields.create) else {
            print("❌ Invalid URL: \(API.Shields.create)")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            let jsonData = try encoder.encode(shield)

            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print("📤 Sending Shield JSON:")
                print(jsonString)
            }

            request.httpBody = jsonData
        } catch {
            print("❌ Failed to encode shield: \(error)")
            completion(false)
            return
        }

        print("🌐 Sending POST request to: \(url.absoluteString)")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Network error: \(error.localizedDescription)")
                completion(false)
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid response")
                completion(false)
                return
            }

            print("📬 Received HTTP status code: \(httpResponse.statusCode)")

            if let data = data, let body = String(data: data, encoding: .utf8) {
                print("📩 Response body:")
                print(body)
            } else {
                print("⚠️ No response body received")
            }

            DispatchQueue.main.async {
                completion(httpResponse.statusCode == 200 || httpResponse.statusCode == 201)
            }
        }.resume()
    }
}

extension Date {
    var iso8601String: String {
        ISO8601DateFormatter().string(from: self)
    }
}
