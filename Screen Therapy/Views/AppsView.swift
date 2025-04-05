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
    @EnvironmentObject var friendsCache: FriendsCache
    @EnvironmentObject var authManager: AuthManager


    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Screen Therapy")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(Color("PrimaryPurple"))

                    // App Picker
                    // App Picker
                    NavigationLink(destination: CreateShieldView(familyActivityModel: familyActivityModel)) {
                        Text("+ Create App Shield")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color("PrimaryPurple"))
                            .cornerRadius(10)
                            .shadow(color: Color("SecondaryPurple").opacity(0.4), radius: 5, x: 0, y: 3)
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
                                                        friendCodeInput = ""
                                                        showAddFriendField = false
                                                        friendsCache.updateCache(with: updatedList)
                                                    }
                                                }
                                            
                                        } else {
                                            print("❌ Failed to add friend")
                                        }
                                    }
                                }
                            }
                        }

                        FriendsListView(friends: friendsCache.cachedFriends)
                    }
                }
                .padding()
            }
            .background(Color("SecondaryPurple").opacity(0.1).edgesIgnoringSafeArea(.all))
            .navigationTitle("Apps")
            .onAppear {
                if friendsCache.cachedFriends.isEmpty {

                        FriendsApi.shared.fetchFriends { fetched in
                            DispatchQueue.main.async {
                                friendsCache.updateCache(with: fetched)
                            }
                        }
                    
                }
            }

        }
    }
}

#Preview {
    AppsView()
        .environmentObject(AuthManager())
        .environmentObject(FriendsCache())
}
