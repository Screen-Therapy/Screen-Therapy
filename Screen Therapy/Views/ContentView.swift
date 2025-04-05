//
//  ContentView.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 1/14/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            AppsView()
                .tabItem {
                    Image(systemName: "app.fill")
                    Text("Apps")
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
        .accentColor(.white) // Optional: sets selected tab icon/text color
    }
}

#Preview {
    ContentView()
        .environmentObject(AuthManager())
        .environmentObject(FriendsCache())
}

