import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme

    let signInHelper = SignInWithAppleHelper()
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background adapts to light/dark mode
                (colorScheme == .dark ? Color.black : Color.white)
                    .ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 25) {
                        // Title
                        Text("Welcome to Screen Therapy")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color("PrimaryPurple"))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .padding(.top, 50)

                        // Input Fields
                        VStack(spacing: 15) {
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

                            Button(action: {
                                // 🔐 Replace with real auth logic
                                if email == "test@example.com" && password == "password" {
                                    authManager.isSignedIn = true
                                } else {
                                    errorMessage = "Invalid credentials"
                                }
                            }) {
                                Text("Sign In")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color("PrimaryPurple"))
                                    .cornerRadius(10)
                            }

                            if let error = errorMessage {
                                Text(error)
                                    .foregroundColor(.red)
                                    .font(.subheadline)
                            }
                        }
                        .padding(.horizontal)

                        // Divider
                        HStack {
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color.gray.opacity(0.4))
                            Text("or")
                                .foregroundColor(.gray)
                            Rectangle()
                                .frame(height: 1)
                                .foregroundColor(Color.gray.opacity(0.4))
                        }
                        .padding(.vertical)

                        // Apple Sign-In
                        SignInWithAppleButton(
                            .signIn,
                            onRequest: { request in
                                request.requestedScopes = [.fullName, .email]
                            },
                            onCompletion: { result in
                                signInHelper.handleSignInResult(result) { success in
                                    if success {
                                        DispatchQueue.main.async {
                                            authManager.isSignedIn = true
                                        }
                                    }
                                }
                            }
                        )
                        .frame(height: 50)
                        .padding(.horizontal)
                        .signInWithAppleButtonStyle(colorScheme == .dark ? .white : .black)

                        Spacer(minLength: 50)

                        // Motivational Quote
                        VStack(spacing: 12) {
                            Text("Small steps today lead to big changes tomorrow.")
                                .font(.footnote)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)

                            HStack(spacing: 10) {
                                FooterLink(title: "Learn More", action: {})
                                FooterLink(title: "Privacy Policy", action: {})
                                FooterLink(title: "Terms", action: {})
                            }
                        }
                        .padding(.top, 50)
                        .padding(.bottom, 20)

                    }
                }
                .scrollDismissesKeyboard(.interactively)

                // Back Button (Top Left)
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

struct FooterLink: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.footnote)
                .foregroundColor(.gray)
                .underline()
        }
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SignInView()
                .environmentObject(AuthManager())
                .preferredColorScheme(.light)

            SignInView()
                .environmentObject(AuthManager())
                .preferredColorScheme(.dark)
        }
    }
}
