//
//  ShieldActionExtension.swift
//  ShieldActionExtension ShieldActionExtension ShieldActionExtension
//
//  Created by Leonardo Cobaleda on 3/20/25.
//

import ManagedSettings
import Foundation

class ShieldActionExtension: ShieldActionDelegate {
    let sharedDefaults = UserDefaults(suiteName: "group.com.777.Screen-Therapy") // Use the App Group

    override func handle(action: ShieldAction, for application: ApplicationToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        switch action {
        case .primaryButtonPressed:
            // Store the user request in UserDefaults
            sharedDefaults?.set(true, forKey: "hasRequestedAccess")
            sharedDefaults?.synchronize() // Ensure data is saved

            // Return .defer so the shield UI updates
            completionHandler(.defer)
        case .secondaryButtonPressed:
            completionHandler(.defer)
        @unknown default:
            fatalError()
        }
    }
    
    override func handle(action: ShieldAction, for webDomain: WebDomainToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        // Handle web domain shield action
        if action == .primaryButtonPressed {
            sharedDefaults?.set(true, forKey: "hasRequestedAccess")
            sharedDefaults?.synchronize()
            completionHandler(.defer)
        } else {
            completionHandler(.close)
        }
    }
    
    override func handle(action: ShieldAction, for category: ActivityCategoryToken, completionHandler: @escaping (ShieldActionResponse) -> Void) {
        // Handle category shield action
        if action == .primaryButtonPressed {
            sharedDefaults?.set(true, forKey: "hasRequestedAccess")
            sharedDefaults?.synchronize()
            completionHandler(.defer)
        } else {
            completionHandler(.close)
        }
    }
}
