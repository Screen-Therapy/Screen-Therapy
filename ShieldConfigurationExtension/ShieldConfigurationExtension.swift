//
//  ShieldConfigurationExtension.swift
//  ShieldConfigurationExtension
//
//  Created by Leonardo Cobaleda on 3/20/25.
//

import ManagedSettings
import ManagedSettingsUI
import UIKit

class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    let sharedDefaults = UserDefaults(suiteName: "group.com.777.Screen-Therapy") // Use the App Group

    override func configuration(shielding application: Application) -> ShieldConfiguration {
        return getUpdatedShieldConfiguration()
    }

    override func configuration(shielding application: Application, in category: ActivityCategory) -> ShieldConfiguration {
        return getUpdatedShieldConfiguration()
    }

    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
        return getUpdatedShieldConfiguration()
    }

    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
        return getUpdatedShieldConfiguration()
    }

    // MARK: - Helper function to return the shield configuration
    private func getUpdatedShieldConfiguration() -> ShieldConfiguration {
        guard
            let data = sharedDefaults?.data(forKey: "activeShield"),
            let shield = try? JSONDecoder().decode(LocalShield.self, from: data)
        else {
            return ShieldConfiguration(
                backgroundBlurStyle: .systemThickMaterial,
                backgroundColor: .white,
                icon: UIImage(systemName: "stopwatch"),
                title: ShieldConfiguration.Label(text: "No app for you", color: .yellow),
                subtitle: ShieldConfiguration.Label(text: "Sorry, no apps for you", color: .white),
                primaryButtonLabel: ShieldConfiguration.Label(text: "Ask for a break?", color: .white),
                secondaryButtonLabel: ShieldConfiguration.Label(text: "Maybe later", color: .white)
            )
        }

        return ShieldConfiguration(
            backgroundBlurStyle: .systemThickMaterial,
            backgroundColor: UIColor(hex: shield.primaryColor) ?? .white,
            icon: UIImage(systemName: shield.icon),
            title: ShieldConfiguration.Label(text: shield.appGroupName, color: .white),
            subtitle: ShieldConfiguration.Label(text: shield.quote ?? "Focus Time", color: .white),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Take a Break", color: .white),
            secondaryButtonLabel: ShieldConfiguration.Label(text: "Not Now", color: .white)
        )
    }

}
struct LocalShield: Codable {
    let appGroupName: String
    let quote: String?
    let icon: String
    let primaryColor: String
}
