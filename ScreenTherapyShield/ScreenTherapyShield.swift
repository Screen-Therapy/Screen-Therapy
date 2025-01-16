//
//  ScreenTherapyShield.swift
//  ScreenTherapyShield
//
//  Created by Leonardo Cobaleda on 1/15/25.
//

import AppIntents

struct ScreenTherapyShield: AppIntent {
    static var title: LocalizedStringResource { "ScreenTherapyShield" }
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}
