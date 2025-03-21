//
//  OptionsView.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 1/14/25.
//
import SwiftUI

struct OptionsView: View {
    var body: some View {
        NavigationView {
            List {
                // General Settings
                Section(header: Text("General").foregroundColor(Color("PrimaryPurple"))) {
                    settingsButton(title: "Appearance", icon: "paintbrush")
                    settingsButton(title: "Language", icon: "globe")
                    settingsButton(title: "Storage & Data", icon: "externaldrive.fill")
                }

                // Privacy & Security
                Section(header: Text("Privacy & Security").foregroundColor(Color("PrimaryPurple"))) {
                    settingsButton(title: "Permissions", icon: "hand.raised.fill")
                    settingsButton(title: "Blocked Users", icon: "person.crop.circle.badge.xmark")
                    settingsButton(title: "Security", icon: "lock.fill")
                }

                // Notifications
                Section(header: Text("Notifications").foregroundColor(Color("PrimaryPurple"))) {
                    settingsButton(title: "Push Notifications", icon: "bell.fill")
                    settingsButton(title: "Email Notifications", icon: "envelope.open.fill")
                }

                // Log Out Section
                Section {
                    LogoutView()
                }
            }
            .navigationTitle("Settings")
            .background(Color("SecondaryPurple").opacity(0.1).edgesIgnoringSafeArea(.all))
            .scrollContentBackground(.hidden) // ✅ Ensures list background matches
        }
    }
}

// ✅ Extracted Button Style
private func settingsButton(title: String, icon: String) -> some View {
    Button(action: {}) {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color("PrimaryPurple")) // ✅ Icon Color
            Text(title)
                .foregroundColor(Color("PrimaryPurple")) // ✅ Text Color
        }
    }
}

#Preview {
    OptionsView()
}
