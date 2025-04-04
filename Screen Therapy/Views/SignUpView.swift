//
//  SignUpView.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 3/31/25.
//

import SwiftUI
import FirebaseAuth
import _AuthenticationServices_SwiftUI

struct SignUpView: View {
    @EnvironmentObject var authManager: AuthManager
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme

    @State private var username = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String?

    @State private var userId = ""
    @State private var showCompleteProfile = false

    let signInHelper = SignInWithAppleHelper()
    let emailHelper = SignInWithEmailHelper()

    var body: some View {
        NavigationView {
            ZStack {
                (colorScheme == .dark ? Color.black : Color.white)
                    .ignoresSafeArea()

                VStack(spacing: 25) {
                    Text("Create Your Account")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(Color("PrimaryPurple"))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top, 75)

                    VStack(spacing: 15) {
                        TextField("Username", text: $username)
                            .padding()
                            .background(colorScheme == .dark ? Color(.systemGray5) : Color.white)
                            .cornerRadius(10)
                            .shadow(color: Color("SecondaryPurple").opacity(0.15), radius: 3, x: 0, y: 1)
                            .autocapitalization(.none)

                        TextField("Email", text: $email)
                            .padding()
                            .background(colorScheme == .dark ? Color(.systemGray5) : Color.white)
                            .cornerRadius(10)
                            .shadow(color: Color("SecondaryPurple").opacity(0.15), radius: 3, x: 0, y: 1)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)

                        SecureField("Password", text: $password)
                            .padding()
                            .background(colorScheme == .dark ? Color(.systemGray5) : Color.white)
                            .cornerRadius(10)
                            .shadow(color: Color("SecondaryPurple").opacity(0.15), radius: 3, x: 0, y: 1)

                        SecureField("Confirm Password", text: $confirmPassword)
                            .padding()
                            .background(colorScheme == .dark ? Color(.systemGray5) : Color.white)
                            .cornerRadius(10)
                            .shadow(color: Color("SecondaryPurple").opacity(0.15), radius: 3, x: 0, y: 1)

                        Button("Sign Up") {
                            registerWithFirebase()
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color("PrimaryPurple"))
                        .cornerRadius(10)

                        if let error = errorMessage {
                            Text(error)
                                .foregroundColor(.red)
                                .font(.subheadline)
                        }
                    }
                    .padding(.horizontal)

                    HStack {
                        Rectangle().frame(height: 1).foregroundColor(Color.gray.opacity(0.4))
                        Text("or").foregroundColor(.gray)
                        Rectangle().frame(height: 1).foregroundColor(Color.gray.opacity(0.4))
                    }
                    .padding(.horizontal)

                    SignInWithAppleButton(
                        .signUp,
                        onRequest: { request in request.requestedScopes = [.email] },
                        onCompletion: { result in
                            signInHelper.handleSignInResult(result) { success, hasUsername in
                                DispatchQueue.main.async {
                                    if success {
                                        if hasUsername {
                                            authManager.completeSetupAfterAppleSignIn()
                                        } else {
                                            userId = KeychainItem.currentUserIdentifier() ?? ""
                                            showCompleteProfile = true
                                        }
                                    } else {
                                        errorMessage = "Apple Sign-Up failed. Try again."
                                    }
                                }
                            }
                        }
                    )
                    .frame(height: 50)
                    .padding(.horizontal)
                    .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)

                    Spacer()

                    VStack(spacing: 12) {
                        Text("Your future self will thank you.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)

                        HStack(spacing: 20) {
                            FooterLink(title: "Learn More", action: {})
                            FooterLink(title: "Privacy Policy", action: {})
                            FooterLink(title: "Terms", action: {})
                        }
                    }
                    .padding(.bottom, 30)
                }
                .padding(.top)
                .navigationDestination(isPresented: $showCompleteProfile) {
                    CompleteProfileView(userId: $userId)
                        .environmentObject(authManager)
                }

                ZStack(alignment: .topLeading) {
                    Color.clear
                    Button(action: { dismiss() }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
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

    func registerWithFirebase() {
        guard password == confirmPassword else {
            errorMessage = "Passwords do not match"
            return
        }

        if username.isEmpty || email.isEmpty || password.isEmpty {
            errorMessage = "Please fill in all fields"
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = "Firebase error: \(error.localizedDescription)"
                return
            }

            guard let userId = result?.user.uid else {
                errorMessage = "Could not retrieve user ID"
                return
            }

            self.userId = userId

            emailHelper.registerUser(userId: userId, username: username, email: email) { success in
                DispatchQueue.main.async {
                    if success {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            authManager.isSignedIn = true
                        }
                    } else {
                        errorMessage = "Sign up failed. Try again."
                    }

                }
            }
        }
    }
}


struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignUpView().environmentObject(AuthManager())
                .preferredColorScheme(.light)
            SignUpView().environmentObject(AuthManager())
                .preferredColorScheme(.dark)
        }
    }
}
