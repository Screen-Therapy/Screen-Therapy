import SwiftUI
import FamilyControls
import ManagedSettings
import ManagedSettingsUI
import Firebase
import AuthenticationServices

@main
struct Screen_TherapyApp: App {
    @StateObject private var authManager = AuthManager() // ✅ Keeps auth state across app relaunches
    @StateObject var friendsCache = FriendsCache()

    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.backgroundColor = UIColor(named: "AccentPurple2") // Custom color
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            RootView() // Uses AuthManager to decide view
                .environmentObject(AuthManager())

                .environmentObject(friendsCache)

        }
    }
}
