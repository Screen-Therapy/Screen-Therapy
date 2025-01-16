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


@main
struct Screen_TherapyApp: App {
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

