//
//  ShieldSettingsView.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 1/14/25.
//

import SwiftUI
import FamilyControls
import ManagedSettings
import ManagedSettingsUI
import UIKit
import Foundation
import DeviceActivity

extension ManagedSettingsStore.Name {
    static let shared = Self("social")
}

struct ShieldSettingsView: View {
    @ObservedObject var familyActivityModel: FamilyActivityModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Shield Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color("PrimaryPurple"))

            Text("Apps Selected: \(familyActivityModel.selectionToDiscourage.applications.count)")
                .font(.headline)

            Text("Websites Selected: \(familyActivityModel.selectionToDiscourage.webDomains.count)")
                .font(.headline)

            Button("Shield") {
                shieldSelectedApplications()
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color("PrimaryPurple"))
            .cornerRadius(10)

            Button("Dismiss") {
                dismiss()
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color("PrimaryPurple"))
            .cornerRadius(10)

            Spacer()
        }
        .padding()
        .background(Color("SecondaryPurple").opacity(0.1).edgesIgnoringSafeArea(.all))
    }

    @Environment(\.dismiss) var dismiss

    func shieldSelectedApplications() {
        let store = ManagedSettingsStore(named: .shared)

        // Apply shield settings for selected applications
        let selectedApplicationsTokens = familyActivityModel.selectionToDiscourage.applicationTokens
        store.shield.applications = selectedApplicationsTokens

        // Apply shield settings for selected web domains
        let selectedWebDomains = familyActivityModel.selectionToDiscourage.webDomainTokens
        store.shield.webDomains = selectedWebDomains

        // Optional: Add logging or feedback for debugging
        print("Shield settings applied for apps: \(selectedApplicationsTokens)")
        print("Shield settings applied for websites: \(selectedWebDomains)")
    }
}

#Preview {
    let mockModel = FamilyActivityModel()
    return ShieldSettingsView(familyActivityModel: mockModel)
}
