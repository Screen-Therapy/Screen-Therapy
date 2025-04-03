//
//  AddFriendButton.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 4/2/25.
//

import SwiftUI

struct AddFriendButton: View {
    @Binding var showField: Bool
    @Binding var friendCodeInput: String
    var onAddFriend: () -> Void
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Button(action: {
                withAnimation {
                    showField.toggle()
                }
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "plus")
                    Text("Add Friend")
                }
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(
                    colorScheme == .light
                        ? Color("PrimaryPurple")
                        : Color(.systemGray5)
                )
                .cornerRadius(10)
            }

            if showField {
                HStack(spacing: 10) {
                    TextField("Enter friend code", text: $friendCodeInput)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.allCharacters)

                    Button("Add") {
                        onAddFriend()
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color("PrimaryPurple"))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .transition(.move(edge: .top).combined(with: .opacity))
            }
        }
    }
}



