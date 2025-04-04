//
//  ContentView.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 1/14/25.
//

import SwiftUI

struct ContentView: View {
    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor(named: "PrimaryPurple")
        tabBarAppearance.stackedLayoutAppearance.selected.iconColor = .white
        tabBarAppearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.white]
        tabBarAppearance.stackedLayoutAppearance.normal.iconColor = UIColor.systemGray4
        tabBarAppearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.systemGray4]
        UITabBar.appearance().standardAppearance = tabBarAppearance

    }
    

    var body: some View {
        TabView {
            AppsView()
                .tabItem {
                    Image(systemName: "app.fill")
                }

            ReportsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Report")
                }

            OptionsView()
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
        .accentColor(.white) // Active tab icon and text color
    }
}


#Preview {
    ContentView().environmentObject(AuthManager()) // Pass mock AuthManager
        .environmentObject(FriendsCache())
}
