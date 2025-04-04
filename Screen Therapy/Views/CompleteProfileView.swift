//
//  CompleteProfileView.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 3/31/25.
//
import SwiftUI
import Combine

struct CompleteProfileView: View {
    @State private var username = ""
    @Binding var userId: String
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme

    @State private var errorMessage: String?
    @State private var navigateToMainApp = false
    @State private var isSaving = false

    var body: some View {
        NavigationStack {
            ZStack {
                (colorScheme == .dark ? Color.black : Color.white)
                    .ignoresSafeArea()

                VStack(spacing: 25) {
                    Spacer()

                    Text("Choose a Username")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color("PrimaryPurple"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)

                    VStack(spacing: 15) {
                        TextField("Username", text: $username)
                            .padding()
                            .background(colorScheme == .dark ? Color(.systemGray5) : Color.white)
                            .cornerRadius(10)
                            .shadow(color: Color("SecondaryPurple").opacity(0.15), radius: 3, x: 0, y: 1)
                            .autocapitalization(.none)
                            .onReceive(Just(username)) { _ in
                                if let error = errorMessage, !error.isEmpty {
                                    errorMessage = nil
                                }
                            }



                        Button(action: {
                            let trimmed = username.trimmingCharacters(in: .whitespacesAndNewlines)

                            if trimmed.isEmpty {
                                errorMessage = "Please enter a username"
                            } else {
                                isSaving = true
                                SignInWithAppleHelper().saveUsername(userId: userId, username: trimmed) { success in
                                    DispatchQueue.main.async {
                                        isSaving = false
                                        if success {
                                            authManager.isSignedIn = true // 🔁 Triggers RootView switch
                                        } else {
                                            errorMessage = "Failed to save username. Try a different one?"
                                        }
                                    }
                                }
                            }
                        }) {
                            if isSaving {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Continue")
                            }
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("PrimaryPurple"))
                        .cornerRadius(10)
                        .disabled(username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSaving)
                        .opacity(username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isSaving ? 0.6 : 1)

                        if let error = errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.subheadline)
                        }
                    }
                    .padding(.horizontal)

                    Spacer()
                }

                // Back Button
                ZStack(alignment: .topLeading) {
                    Color.clear

                    Button(action: {
                        dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .medium))
                            Text("Back")
                                .font(.system(size: 16))
                        }
                        .foregroundColor(.gray)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(12)
                        .shadow(radius: 2)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(.top, 10)
                .padding(.leading, 16)
            }
        }
    }
}

struct CompleteProfileView_Previews: PreviewProvider {
    @State static var testUserId = "12345"
    static var previews: some View {
        Group {
            CompleteProfileView(userId: $testUserId)
                .environmentObject(AuthManager())
                .preferredColorScheme(.light)

            CompleteProfileView(userId: $testUserId)
                .environmentObject(AuthManager())
                .preferredColorScheme(.dark)
        }
    }
}
