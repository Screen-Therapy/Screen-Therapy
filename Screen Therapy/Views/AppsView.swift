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

    var body: some View {
        NavigationView {
            VStack(spacing: 20) { // Add spacing between elements
                Text("Screen Therapy")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color("PrimaryPurple")) // Use PrimaryPurple

                Button(action: {
                    isPresented = true
                }) {
                    Text("Select Apps to Discourage")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity) // Full-width button
                        .background(Color("PrimaryPurple"))
                        .cornerRadius(10) // Rounded corners
                        .shadow(color: Color("SecondaryPurple").opacity(0.4), radius: 5, x: 0, y: 3) // Add shadow
                }
                .familyActivityPicker(isPresented: $isPresented, selection: $familyActivityModel.selectionToDiscourage)

                Spacer() // Push the content upwards
            }
            .padding()
            .background(Color("SecondaryPurple").opacity(0.1).edgesIgnoringSafeArea(.all)) // Light background tint
            .navigationTitle("Apps")
        }
    }
}

#Preview {
    AppsView()
}
