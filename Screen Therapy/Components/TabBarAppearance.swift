//
//  TabBarAppearance.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 4/5/25.
//

import SwiftUI

struct TabBarAppearance {
    static func configure() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()

        // Dynamic color support
        appearance.backgroundColor = UIColor(named: "AccentPurple2") ?? UIColor.systemBackground

        appearance.stackedLayoutAppearance.selected.iconColor = .white
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.systemGray4
        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.systemGray4]

        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}
