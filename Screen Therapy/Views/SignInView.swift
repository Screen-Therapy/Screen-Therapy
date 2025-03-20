////
////  SignInView.swift
////  Screen Therapy
////
////  Created by Leonardo Cobaleda on 1/17/25.
////
//
//import SwiftUI
//import AuthenticationServices
//import Firebase
//import CryptoKit
//struct SignInView: View {
//    @State private var errorMessage: String = ""
//    @State private var showAlert: Bool = false
//    @State private var nonce: String?
//    var body: some View {
//        VStack(spacing: 20) {
//            Text("Let's create your account")
//                .font(.largeTitle)
//                .fontWeight(.bold)
//                .multilineTextAlignment(.center)
//                .foregroundColor(.white)
//
//            
//            Text("Join others on their journey together")
//                .font(.subheadline)
//                .foregroundColor(.white)
//                .multilineTextAlignment(.center)
//                .padding(.bottom, 40)
//            
//            TextField("Your email", text: .constant(""))
//                .padding()
//                .foregroundColor(.white)
//                .background(Color.clear)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.gray, lineWidth: 1)
//                )
//                .padding(.horizontal)
//            
//            SecureField("Password", text: .constant(""))
//                .padding()
//                .foregroundColor(.gray)
//                .background(Color.clear)
//                .overlay(
//                    RoundedRectangle(cornerRadius: 10)
//                        .stroke(Color.gray, lineWidth: 1)
//                )
//                .padding(.horizontal)
//            
//            Button(action: {
//                // Action here (to be implemented later)
//            }) {
//                Text("Create Account")
//                    .font(.headline)
//                    .foregroundColor(.black)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color.white)
//                    .cornerRadius(10)
//            }
//            .padding(.horizontal)
//            
//            HStack {
//                VStack {
//                    Color.white.frame(height: 1 / UIScreen.main.scale)
//                }
//                Text("or")
//                    .font(.subheadline)
//                    .foregroundColor(.gray)
//                    .padding(.horizontal)
//                VStack {
//                    Color.white.frame(height: 1 / UIScreen.main.scale)
//                }
//            }
//            .padding(.horizontal)
//            
//            VStack(alignment: .leading){
//                
//                SignInWithAppleButton(onRequest: request in  let nonce = randomNonceString()  self.nonce = nonce request.requestedScopes = {.email, .fullName} request.nonce = sha256(), onCompletion: result in switch{
//                case success(let authorization):
//                    loginWithFirebase(authorrization)
//                case .failure(let error):
//                    showError(error.localizedDescription)
//                })
//                .frame(height: 45)
//                .clipShape(.capsule)
//            }
//            .alert(errorMessage, isPresented: $showAlert, actions: <#T##() -> View#>)
//            Spacer()
//        }
//        .padding()
//        .background(
//            AngularGradient(
//                gradient: Gradient(colors: [
//                    Color(hue: 0.7, saturation: 0.8, brightness: 0.4),
//                    Color(hue: 0.65, saturation: 0.9, brightness: 0.3),
//                    Color(hue: 0.6, saturation: 0.85, brightness: 0.35),
//                    Color(hue: 0.7, saturation: 0.8, brightness: 0.4)
//                ]),
//                center: .center
//            )
//            .ignoresSafeArea()
//        )
//    }
//    
//}
//func showError(_ message: String){
//    errorMessage = message
//    showAlert.toggle()
//}
//func loginWithFirebase(_ authorization: ASAuthorization){
//    if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
//          guard let nonce else {
//              
//            //fatalError("Invalid state: A login callback was received, but no login request was sent.")
//              showError("Cannot process your request")
//              return
//          }
//          guard let appleIDToken = appleIDCredential.identityToken else {
//            //print("Unable to fetch identity token")
//              showError("Cannot process your request")
//              return
//          }
//          guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
//            //print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
//              showError("Cannot process your request")
//              return
//          }
//          // Initialize a Firebase credential, including the user's full name.
//          let credential = OAuthProvider.appleCredential(withIDToken: idTokenString,
//                                                            rawNonce: nonce,
//                                                            fullName: appleIDCredential.fullName)
//          // Sign in with Firebase.
//          Auth.auth().signIn(with: credential) { (authResult, error) in
//            if let rror {
//              // Error. If error.code == .MissingOrInvalidNonce, make sure
//              // you're sending the SHA256-hashed nonce as a hex string with
//              // your request to Apple.
//                showError(error.localizedDescription)
//              return
//            }
//            // User is signed in to Firebase with Apple.
//            // ...
//          }
//        }
//}
//
//private func randomNonceString(length: Int = 32) -> String {
//  precondition(length > 0)
//  var randomBytes = [UInt8](repeating: 0, count: length)
//  let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
//  if errorCode != errSecSuccess {
//    fatalError(
//      "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
//    )
//  }
//
//  let charset: [Character] =
//    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
//
//  let nonce = randomBytes.map { byte in
//    // Pick a random character from the set, wrapping around if needed.
//    charset[Int(byte) % charset.count]
//  }
//
//  return String(nonce)
//}
//
//    private func sha256(_ input: String) -> String {
//  let inputData = Data(input.utf8)
//  let hashedData = SHA256.hash(data: inputData)
//  let hashString = hashedData.compactMap {
//    String(format: "%02x", $0)
//  }.joined()
//
//  return hashString
//}
//
//    
//    
//
//#Preview {
//    SignInView()
//}
