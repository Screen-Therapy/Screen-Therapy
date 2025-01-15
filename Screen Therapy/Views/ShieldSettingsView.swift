//
//  ShieldSettingsView.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 1/14/25.
//

import SwiftUI
import FamilyControls
import ManagedSettings


struct ShieldSettingsView: View {
    @ObservedObject var familyActivityModel: FamilyActivityModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Shield Settings")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color("PrimaryPurple"))

            Text("Apps Selected: \(familyActivityModel.selectionToDiscourage.applications.count)")
                .font(.headline)

            Text("Websites Selected: \(familyActivityModel.selectionToDiscourage.webDomains.count)")
                .font(.headline)
            
            Button("Shield"){
                shieldSelectedApplications()
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color("PrimaryPurple"))
            .cornerRadius(10)

            Button("Dismiss") {
                dismiss()
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .background(Color("PrimaryPurple"))
            .cornerRadius(10)

            Spacer()
        }
        .padding()
        .background(Color("SecondaryPurple").opacity(0.1).edgesIgnoringSafeArea(.all))
    }

    @Environment(\.dismiss) var dismiss
    
    func shieldSelectedApplications(){
        let selectedApplicationsTokens = familyActivityModel.selectionToDiscourage.applicationTokens
                let store = ManagedSettingsStore()

                store.shield.applications = selectedApplicationsTokens
    }
}


#Preview {
    let mockModel = FamilyActivityModel()
    return ShieldSettingsView(familyActivityModel: mockModel)
}
