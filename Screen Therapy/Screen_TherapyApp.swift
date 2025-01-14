//
//  Screen_TherapyApp.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 1/14/25.
//

import SwiftUI
import FamilyControls

@main
struct Screen_TherapyApp: App {
    let center = AuthorizationCenter.shared

    var body: some Scene {
        WindowGroup {
            VStack {
                ContentView()
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

