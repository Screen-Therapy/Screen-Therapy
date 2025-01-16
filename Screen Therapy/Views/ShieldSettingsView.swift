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
            
            Button("Shield"){
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
    
    func shieldSelectedApplications(){
        let selectedApplicationsTokens = familyActivityModel.selectionToDiscourage.applicationTokens
                let store = ManagedSettingsStore()

                store.shield.applications = selectedApplicationsTokens
    }
}


class STShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(shielding application: Application) -> ShieldConfiguration {

        return ShieldConfiguration(
            backgroundBlurStyle: UIBlurEffect.Style.systemMaterialLight,
            backgroundColor: UIColor(red: 0.71, green: 0.66, blue: 0.98, alpha: 1.00),
            icon: UIImage(named: "ShieldLogo"),
            title: ShieldConfiguration.Label(text: "Life is short.", color: .black),
            subtitle: ShieldConfiguration.Label(text: "But if you wanna use this app, let’s make sure to pay.", color: .black),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Thanks!", color: .white),
            primaryButtonBackgroundColor: UIColor.black,
            secondaryButtonLabel: ShieldConfiguration.Label(text: "Break 👀", color: .black)
        )
    }
}
#Preview {
    let mockModel = FamilyActivityModel()
    return ShieldSettingsView(familyActivityModel: mockModel)
}
