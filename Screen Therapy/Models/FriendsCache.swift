//
//  FriendsCache.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 4/3/25.
//

import SwiftUI

class FriendsCache: ObservableObject {
    @AppStorage("cachedFriends") var cachedFriendsData: String = "" {
        didSet {
            decodeCachedFriends()
        }
    }

    @Published var cachedFriends: [Friend] = []

    init() {
        decodeCachedFriends()
    }

    private func decodeCachedFriends() {
        guard !cachedFriendsData.isEmpty,
              let data = cachedFriendsData.data(using: .utf8) else {
            cachedFriends = []
            return
        }

        do {
            let decoded = try JSONDecoder().decode([Friend].self, from: data)
            cachedFriends = decoded
        } catch {
            print("❌ Failed to decode cached friends: \(error)")
            cachedFriends = []
        }
    }


    func updateCache(with friends: [Friend]) {
        do {
            let data = try JSONEncoder().encode(friends)
            cachedFriendsData = String(data: data, encoding: .utf8) ?? ""
        } catch {
            print("❌ Failed to encode friends for cache: \(error)")
        }
    }

    func clearCache() {
        print("🧼 Clearing friend cache...")
        cachedFriendsData = ""
        cachedFriends = []
    }
}
