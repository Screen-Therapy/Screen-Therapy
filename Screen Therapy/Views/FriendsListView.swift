//
//  FriendsListView.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 3/31/25.
//

import StoreKit
import SwiftUI

struct FriendsListView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var showAll = false

    // This will be passed from parent
    var friends: [Friend]

    var visibleFriends: [Friend] {
        showAll ? friends : Array(friends.prefix(5))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
         

            ForEach(visibleFriends) { friend in
                FriendBlock(friend: friend)
            }

            if friends.count > 5 {
                Button(action: {
                    showAll.toggle()
                }) {
                    HStack(spacing: 4) {
                        Text(showAll ? "See Less" : "See All")
                        Image(systemName: showAll ? "chevron.up" : "chevron.down")
                    }
                    .foregroundColor(Color("PrimaryPurple"))
                    .font(.subheadline)
                    .padding(.horizontal)
                }
                .padding(.top, 5)
            }
        }
        .padding(.vertical)
    }
}

// MARK: - Preview

#Preview {
    FriendsListView(friends: [
        Friend(userId: "1", username: "pablo23"),
        Friend(userId: "2", username: "emma"),
        Friend(userId: "3", username: "leo32"),
        Friend(userId: "4", username: "mariacodez"),
        Friend(userId: "5", username: "josephAI"),
        Friend(userId: "6", username: "anotherUser")
    ])
    .environment(\.colorScheme, .dark)
}

