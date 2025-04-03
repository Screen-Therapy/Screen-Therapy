//
//  FriendBlockView.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 4/2/25.
//

import SwiftUI

struct FriendBlock: View {
    @Environment(\.colorScheme) var colorScheme
    var friend: Friend

    var body: some View {
        HStack {
            Image("ProfileIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .padding(.leading, 10)

            Text(friend.username)
                .foregroundColor(colorScheme == .dark ? .white : .white)
                .fontWeight(.medium)
                .padding(.leading, 8)

            Spacer()
        }
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(colorScheme == .dark ? Color(.systemGray5) : Color("PrimaryPurple"))
        )
        .padding(.horizontal)
    }
}

