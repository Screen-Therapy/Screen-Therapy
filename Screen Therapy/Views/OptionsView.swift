//
//  OptionsView.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 1/14/25.
//
import SwiftUI

struct OptionsView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var authManager: AuthManager
    @State private var username: String = UserDefaults.standard.string(forKey: "username") ?? ""
    @State private var friendCode: String = UserDefaults.standard.string(forKey: "friendCode") ?? ""
    @State private var hasFetched: Bool = false

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

                // MARK: - Settings Actions
                VStack(spacing: 16) {
                    settingsButton(title: "Friends List", icon: "person.2.fill", colorScheme: colorScheme)
                    settingsButton(title: "Enter Friend Code", icon: "plus.circle.fill", colorScheme: colorScheme)
                    settingsButton(title: "Appearance", icon: "paintbrush", colorScheme: colorScheme)
                    settingsButton(title: "Permissions", icon: "hand.raised.fill", colorScheme: colorScheme)
                    settingsButton(title: "Blocked Users", icon: "person.crop.circle.badge.xmark", colorScheme: colorScheme)
                    settingsButton(title: "Push Notifications", icon: "bell.fill", colorScheme: colorScheme)
                    logoutButton(colorScheme: colorScheme)
                }
                .padding(.horizontal)

                Spacer()
            }
            .background(colorScheme == .dark ? Color.black : Color.white)
            .navigationTitle("Settings")
            .onAppear {
                if !hasFetched {
                    FriendsApi.shared.fetchUserDetails { fetchedUsername, fetchedCode in
                        DispatchQueue.main.async {
                            if let fetchedUsername = fetchedUsername {
                                self.username = fetchedUsername
                                UserDefaults.standard.set(fetchedUsername, forKey: "username")
                            }

                            if let fetchedCode = fetchedCode {
                                self.friendCode = fetchedCode
                                UserDefaults.standard.set(fetchedCode, forKey: "friendCode")
                            }

                            self.hasFetched = true
                        }
                    }
                }
            }
        }
    }

    // MARK: - Reusable Primary Buttons
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
        .buttonStyle(PlainButtonStyle())
    }

    // MARK: - Logout Button (Secondary Styling)
    private func logoutButton(colorScheme: ColorScheme) -> some View {
        Button(action: {
            KeychainItem.deleteUserIdentifier()
            authManager.isSignedIn = false
        }) {
            HStack(spacing: 6) {
                Image(systemName: "arrow.backward.circle.fill")
                    .foregroundColor(.white)

                Text("Log Out")
                    .foregroundColor(.white)

                Spacer()
            }
            .padding()
            .background(Color("SecondaryPurple"))
            .cornerRadius(10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    OptionsView()
        .environment(\.colorScheme, .dark)
        .environmentObject(AuthManager())
}
