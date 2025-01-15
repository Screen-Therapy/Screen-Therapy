//
//  AppsView.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 1/14/25.
//

import SwiftUI
import FamilyControls

struct AppsView: View {
    @StateObject var familyActivityModel = FamilyActivityModel()
    @State private var isPresented = false
    @State private var showShieldSettings = false // State to show/hide the popup

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Screen Therapy")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("PrimaryPurple"))

                // Family Activity Picker Button
                Button(action: {
                    isPresented = true
                }) {
                    Text("Select Apps to Discourage")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("PrimaryPurple"))
                        .cornerRadius(10)
                        .shadow(color: Color("SecondaryPurple").opacity(0.4), radius: 5, x: 0, y: 3)
                }
                .familyActivityPicker(isPresented: $isPresented, selection: $familyActivityModel.selectionToDiscourage)
                .onChange(of: isPresented) { newValue in
                    if !newValue && !familyActivityModel.selectionToDiscourage.applications.isEmpty {
                        // When picker is dismissed and apps are selected
                        showShieldSettings = true
                    }
                }

                Spacer()
            }
            .padding()
            .background(Color("SecondaryPurple").opacity(0.1).edgesIgnoringSafeArea(.all))
            .navigationTitle("Apps")
            .sheet(isPresented: $showShieldSettings) {
                ShieldSettingsView(familyActivityModel: familyActivityModel)
            }
        }
    }
}

#Preview {
    AppsView()
}
