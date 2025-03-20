//
//  Screen_TherapyApp.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 1/14/25.
//

import SwiftUI
import FamilyControls
import ManagedSettings
import ManagedSettingsUI
import Firebase

@main
struct Screen_TherapyApp: App {
    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = UIColor(named: "AccentPurple2") // Custom color
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        FirebaseApp.configure()
       }
  
    let center = AuthorizationCenter.shared

    var body: some Scene {
        WindowGroup {
            VStack {
                WelcomeView()
            }
            
            .onAppear {
                Task {
                    do {
                        try await center.requestAuthorization(for: .individual)
                        print("Authorization request successful.")
                    } catch {
                        print("Failed to enroll user with error: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
