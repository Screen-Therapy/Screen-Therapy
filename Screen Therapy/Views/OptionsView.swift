//
//  OptionsView.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 1/14/25.
//
import SwiftUI

struct OptionsView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var username: String = ""
    @State private var friendCode: String = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                // MARK: - Profile Header
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(colorScheme == .dark ? Color("PrimaryPurple") : Color.white)
                            .frame(width: 90, height: 90)
                            .shadow(radius: 5)

                        Image("ProfileIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                    }

                    Text(username.isEmpty ? "Loading..." : username)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("PrimaryPurple"))

                    Text(friendCode.isEmpty ? "" : "Friend Code: \(friendCode)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                .padding(.top, 50)

                // MARK: - Settings List
                List {
                    Section(header: Text("General").foregroundColor(Color("PrimaryPurple"))) {
                        settingsButton(title: "Appearance", icon: "paintbrush", colorScheme: colorScheme)
                    }

                    Section(header: Text("Privacy & Security").foregroundColor(Color("PrimaryPurple"))) {
                        settingsButton(title: "Permissions", icon: "hand.raised.fill", colorScheme: colorScheme)
                        settingsButton(title: "Blocked Users", icon: "person.crop.circle.badge.xmark", colorScheme: colorScheme)
                    }

                    Section(header: Text("Notifications").foregroundColor(Color("PrimaryPurple"))) {
                        settingsButton(title: "Push Notifications", icon: "bell.fill", colorScheme: colorScheme)
                    }

                    Section {
                        LogoutView()
                    }
                }
                .scrollContentBackground(.hidden)
                .background(colorScheme == .dark ? Color.black : Color.white)
                .listStyle(.insetGrouped)
            }
            .background(colorScheme == .dark ? Color.black : Color.white)
            .navigationTitle("Settings")
            .onAppear {
                FriendsApi.shared.fetchUserDetails { fetchedUsername, fetchedCode in
                    DispatchQueue.main.async {
                        self.username = fetchedUsername ?? ""
                        self.friendCode = fetchedCode ?? ""
                    }
                }
            }
        }
    }
}


// MARK: - Reusable Button
private func settingsButton(title: String, icon: String, colorScheme: ColorScheme) -> some View {
    Button(action: {
        // Your action here
    }) {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .foregroundColor(colorScheme == .light ? .white : Color("PrimaryPurple"))

            Text(title)
                .foregroundColor(colorScheme == .light ? .white : .gray)

            Spacer()
        }
        .padding()
        .background(
            colorScheme == .light
                ? Color("PrimaryPurple")
                : Color(.systemGray5)
        )
        .cornerRadius(10)
    }
    .buttonStyle(PlainButtonStyle()) // Keeps custom styling
}


#Preview {
    OptionsView()
        .environment(\.colorScheme, .dark) // Toggle between .light or .dark
}
