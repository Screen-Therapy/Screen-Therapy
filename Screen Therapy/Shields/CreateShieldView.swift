//
//  CreateShieldView.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 4/5/25.
//

import SwiftUI
import FamilyControls
import ManagedSettings
import DeviceActivity

extension ManagedSettingsStore.Name {
    static let shared = Self("screen-therapy-store")
}

struct CreateShieldView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var familyActivityModel: FamilyActivityModel
    @EnvironmentObject var authManager: AuthManager

    // Shield config states
    @State private var appGroupName = ""
    @State private var quote = ""
    @State private var reason = ""
    @State private var blockType = "strict"
    @State private var challengeType = "none"
    @State private var durationHours = 1
    @State private var durationMinutes = 0
    @State private var startTime = Date()
    @State private var endTime = Calendar.current.date(byAdding: .hour, value: 1, to: Date()) ?? Date()
    @State private var repeatDays: [String] = []
    @State private var icon = "stopwatch"
    @State private var primaryColor: Color = Color("PrimaryPurple")
    @State private var secondaryColor: Color = Color("SecondaryPurple")
    @State private var useDurationInsteadOfTime = true

    @State private var isAppPickerPresented = false

    // Info toggle states
    @State private var showBlockTypeInfo = false
    @State private var showChallengeTypeInfo = false
    @State private var showIconPicker = false

    let allDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    let iconOptions = ["stopwatch", "book", "brain.head.profile", "shield", "bolt", "hourglass", "clock", "lock", "timer"]

    var body: some View {
        ZStack {
            Color(.systemBackground).edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack(spacing: 20) {
                    titleSection

                    Button(action: {
                        isAppPickerPresented = true
                    }) {
                        Text("+ Select Apps to Discourage")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(primaryColor)
                            .cornerRadius(10)
                    }
                    .familyActivityPicker(isPresented: $isAppPickerPresented, selection: $familyActivityModel.selectionToDiscourage)

                    section(title: "Shield Details") {
                        TextField("App Group Name (e.g. Study Block)", text: $appGroupName)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)

                        TextField("Quote (optional)", text: $quote)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)

                        TextField("Reason (optional)", text: $reason)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(8)
                    }

                    section(title: "Icon Selection") {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(iconOptions, id: \.self) { symbol in
                                    Button(action: { icon = symbol }) {
                                        Image(systemName: symbol)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 30, height: 30)
                                            .padding(10)
                                            .background(icon == symbol ? primaryColor : Color(.secondarySystemBackground))
                                            .foregroundColor(icon == symbol ? .white : .primary)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                            .shadow(radius: 2)
                                    }
                                }
                            }
                        }
                    }

                    section(title: "Block Type", info: $showBlockTypeInfo, description: "Defines how strict the shield is...") {
                        Picker("", selection: $blockType) {
                            Text("Strict").tag("strict")
                            Text("Semi-Strict").tag("semi_strict")
                            Text("Not Strict").tag("not_strict")
                        }
                        .pickerStyle(.segmented)
                    }

                    section(title: "Challenge Type", info: $showChallengeTypeInfo, description: "Optional challenge to remove shield...") {
                        Picker("", selection: $challengeType) {
                            Text("None").tag("none")
                            Text("Math").tag("math")
                            Text("Typing").tag("typing")
                            Text("Custom").tag("custom")
                        }
                        .pickerStyle(.segmented)
                    }

                    section(title: "Time Restriction") {
                        Toggle("Use Duration Instead of Time Range", isOn: $useDurationInsteadOfTime)
                        if useDurationInsteadOfTime {
                            HStack(spacing: 10) {
                                Picker("Hours", selection: $durationHours) {
                                    ForEach(0..<24) { Text("\($0)h") }
                                }.pickerStyle(.wheel)

                                Picker("Minutes", selection: $durationMinutes) {
                                    ForEach(0..<60) { Text("\($0)m") }
                                }.pickerStyle(.wheel)
                            }
                            .frame(height: 100)
                        } else {
                            DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                            DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
                        }
                    }

                    section(title: "Repeat Days") {
                        HStack {
                            Button(action: {
                                if repeatDays.count == allDays.count {
                                    repeatDays.removeAll()
                                } else {
                                    repeatDays = allDays
                                }
                            }) {
                                Text(repeatDays.count == allDays.count ? "Unselect All" : "Select All")
                                    .font(.caption)
                                    .padding(8)
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(8)
                            }

                            Spacer()
                        }

                        HStack {
                            ForEach(allDays, id: \.self) { day in
                                Button(action: {
                                    if repeatDays.contains(day) {
                                        repeatDays.removeAll { $0 == day }
                                    } else {
                                        repeatDays.append(day)
                                    }
                                }) {
                                    Text(String(day.prefix(3)))
                                        .font(.caption)
                                        .padding(8)
                                        .background(repeatDays.contains(day) ? primaryColor : Color.gray.opacity(0.2))
                                        .foregroundColor(.white)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }

                    section(title: "Customize Colors") {
                        ColorPicker("Primary Color", selection: $primaryColor)
                        ColorPicker("Secondary Color", selection: $secondaryColor)
                    }

                    section(title: "Summary") {
                        Text("Apps Selected: \(familyActivityModel.selectionToDiscourage.applications.count)")
                        Text("Websites Selected: \(familyActivityModel.selectionToDiscourage.webDomains.count)")
                    }

                    createButton
                }
                .padding()
            }
        }
        .navigationTitle("Create Shield")
        .navigationBarTitleDisplayMode(.inline)
        .tabBarHidden(true)
    }

    func section<Content: View>(title: String, info: Binding<Bool>? = nil, description: String? = nil, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(primaryColor)
                if let info = info {
                    Button(action: { info.wrappedValue.toggle() }) {
                        Image(systemName: "info.circle")
                            .foregroundColor(.gray)
                    }
                }
            }

            if let info = info, info.wrappedValue, let description = description {
                Text(description)
                    .font(.footnote)
                    .foregroundColor(.gray)
            }

            VStack(spacing: 12) {
                content()
            }
            .padding()
            .background(Color(.secondarySystemBackground))
            .cornerRadius(12)
        }
    }

    var titleSection: some View {
        Text("Create Shield")
            .font(.largeTitle)
            .fontWeight(.bold)
            .foregroundColor(primaryColor)
    }

    var createButton: some View {
        Button("Create Shield") {
            createShield()
        }
        .font(.headline)
        .foregroundColor(.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background(primaryColor)
        .cornerRadius(10)
    }

    func createShield() {
        let blockedAppTokens = familyActivityModel.selectionToDiscourage.applicationTokens
        let blockedWebTokens = familyActivityModel.selectionToDiscourage.webDomainTokens
           // 🚨 Check if user selected anything at all
        guard (familyActivityModel.selectionToDiscourage.applications.count > 0 ||
               familyActivityModel.selectionToDiscourage.webDomains.count > 0) else {
            print("❌ No apps or websites selected — cannot create shield")
            return
        }

        let store = ManagedSettingsStore(named: .shared)
        store.shield.applications = blockedAppTokens
        store.shield.webDomains = blockedWebTokens

        

        

        let totalDurationMin = (durationHours * 60) + durationMinutes

        let shieldData = ShieldRequest(
            ownerUserId: authManager.userId ?? "",
            createdByUserId: authManager.userId ?? "",
            appGroupName: appGroupName,
            blockType: blockType,
            challengeType: challengeType,
            totalDurationMin: totalDurationMin,
            startTime: useDurationInsteadOfTime ? nil : startTime.iso8601String,
            endTime: useDurationInsteadOfTime ? nil : endTime.iso8601String,
            repeatDays: repeatDays,
            quote: quote,
            icon: icon,
            primaryColor: primaryColor.hex ?? "#000000",
            secondaryColor: secondaryColor.hex ?? "#FFFFFF",
            reason: reason,
            status: "active",
            createdAt: Date().iso8601String
        )

        ShieldManager.createShield(shieldData) { success in
            if success {
                let localShield = LocalShield(
                    appGroupName: appGroupName,
                    quote: quote,
                    icon: icon,
                    primaryColor: primaryColor.hex ?? "#000000"
                )

                if let encoded = try? JSONEncoder().encode(localShield) {
                    UserDefaults(suiteName: "group.com.777.Screen-Therapy")?.set(encoded, forKey: "activeShield")
                }
                
                dismiss()
            } else {
                print("❌ Failed to create shield")
            }
        }
    }

    struct LocalShield: Codable {
        let appGroupName: String
        let quote: String?
        let icon: String
        let primaryColor: String
    }
}

#Preview {
    NavigationView {
        let mockModel = FamilyActivityModel()
        CreateShieldView(familyActivityModel: mockModel)
    }
}
