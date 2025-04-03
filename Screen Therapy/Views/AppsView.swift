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
    @State private var showShieldSettings = false
    @State private var showAddFriendField = false
    @State private var friendCodeInput = ""
    @State private var friends: [Friend] = []

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Screen Therapy")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("PrimaryPurple"))

                    // App picker
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
                            showShieldSettings = true
                        }
                    }

                    // Friends Section
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text("Friends List")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("PrimaryPurple"))

                            Spacer()

                            AddFriendButton(showField: $showAddFriendField, friendCodeInput: $friendCodeInput) {
                                FriendsApi.shared.addFriend(friendCode: friendCodeInput) { success in
                                    DispatchQueue.main.async {
                                        if success {
                                            FriendsApi.shared.fetchFriends { updatedList in
                                                DispatchQueue.main.async {
                                                    self.friends = updatedList
                                                    friendCodeInput = ""
                                                    showAddFriendField = false
                                                }
                                            }
                                        } else {
                                            print("❌ Failed to add friend")
                                        }
                                    }
                                }
                            }

                        }

                

                        FriendsListView(friends: friends)
                    }
                }
                .padding()
            }
            .background(Color("SecondaryPurple").opacity(0.1).edgesIgnoringSafeArea(.all))
            .navigationTitle("Apps")
            .sheet(isPresented: $showShieldSettings) {
                ShieldSettingsView(familyActivityModel: familyActivityModel)
            }
            .onAppear {
                FriendsApi.shared.fetchFriends { fetched in
                    DispatchQueue.main.async {
                        self.friends = fetched
                    }
                }
            }
        }
    }
}

#Preview {
    AppsView()
}
