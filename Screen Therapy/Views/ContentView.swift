//
//  ContentView.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 1/14/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            TabView {
                AppsView()
                    .tabItem {
                        Label("Apps", systemImage: "app.fill")
                    }
                
                ReportsView()
                    .tabItem {
                        Label("Report", systemImage: "chart.bar.fill")
                    }
                
                OptionsView()
                    .tabItem {
                        Label("Options", systemImage: "gearshape.fill")
                    }
            }
            .accentColor(Color("AccentPurple"))
        }
    }
}

#Preview {
    ContentView()
}
