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
        let hasRequestedAccess = sharedDefaults?.bool(forKey: "hasRequestedAccess") ?? false

        return ShieldConfiguration(
            backgroundBlurStyle: .systemThickMaterial,
            backgroundColor: UIColor.white,
            icon: UIImage(systemName: "stopwatch"),
            title: ShieldConfiguration.Label(
                text: hasRequestedAccess ? "Break Requested" : "No app for you",
                color: .yellow
            ),
            subtitle: ShieldConfiguration.Label(
                text: hasRequestedAccess ? "Waiting for approval" : "Sorry, no apps for you",
                color: .white
            ),
            primaryButtonLabel: ShieldConfiguration.Label(text: "Ask for a break?", color: .white),
            secondaryButtonLabel: ShieldConfiguration.Label(text: "Maybe later", color: .white)
        )
    }
}
