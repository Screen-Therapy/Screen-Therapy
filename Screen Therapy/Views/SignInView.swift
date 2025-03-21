import SwiftUI
import AuthenticationServices

struct SignInView: View {
    @EnvironmentObject var authManager: AuthManager // Access authentication state
    let signInHelper = SignInWithAppleHelper()
    
    var body: some View {
        VStack {
            SignInWithAppleButton(
                .signIn,
                onRequest: { request in
                    request.requestedScopes = [.fullName, .email]
                },
                onCompletion: { result in
                    signInHelper.handleSignInResult(result) { success in
                        if success {
                            DispatchQueue.main.async {
                                authManager.isSignedIn = true // ✅ Navigate to ContentView()
                            }
                        }
                    }
                }
            )
            .frame(width: 250, height: 50)
            .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
    }
}

struct SignInView_Previews: PreviewProvider {
    static var previews: some View {
        SignInView().environmentObject(AuthManager()) // Provide auth state
    }
}
