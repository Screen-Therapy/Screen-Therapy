//
//  WelcomeView.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 1/15/25.
//
import SwiftUI

struct WelcomeView: View {
    @State private var currentPage = 0
    @State private var timer: Timer? = nil
    @State private var navigateToMainApp = false
    @State private var isSignUp = true



    var body: some View {
        NavigationStack {
            VStack {
                // Custom Slider
                HStack(spacing: 8) {
                    ForEach(0..<3) { index in
                        Rectangle()
                            .fill(index == currentPage ? Color("WelcomeColor") : Color.gray.opacity(0.5))
                            .frame(width: 40, height: 5)
                            .cornerRadius(2.5)
                    }
                }
                .padding(.top, 10)

                // TabView for Pages
                TabView(selection: $currentPage) {
                    PageView(
                        title: "Welcome to Screen Therapy",
                        subheading: "Discover balance & productivity. Take control of your time and start living today.",
                        imageName: "ShieldLogo",
                        direction: .right
                    ).tag(0)

                    PageView(
                        title: "Learn About Your Habits",
                        subheading: "Make impactful changes in your day-to-day life.",
                        imageName: "ShieldLogo",
                        direction: .left
                    ).tag(1)

                    PageView(
                        title: "Feel the Benefits of some some",
                        subheading: "Experience the positive changes in your productivity and well-being.",
                        imageName: "ShieldLogo",
                        direction: .right
                    ).tag(2)
                }
                .tabViewStyle(.page)
                .indexViewStyle(.page(backgroundDisplayMode: .never))
                .onAppear {
                    startTimer()
                }
                .onDisappear {
                    stopTimer()
                }
                .onChange(of: currentPage) { _ in
                    restartTimer() // Restart the timer when the page changes
                }

                // Buttons
                VStack(spacing: 16) {
                    // Get Started → Sign Up
                    Button("Get Started") {
                        navigateToMainApp = true
                        isSignUp = true
                    }
                    .font(.title2)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("WelcomeColor"))
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding(.horizontal, 20)

                    // Already have an account? → Sign In
                    Button(action: {
                        navigateToMainApp = true
                        isSignUp = false
                    }) {
                        Text("Already have an account?")
                            .font(.headline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.bottom, 20)

                // Navigation
                .navigationDestination(isPresented: $navigateToMainApp) {
                    Group {
                        if isSignUp {
                            SignUpView()
                        } else {
                            SignInView()
                        }
                    }
                    .navigationBarBackButtonHidden(true)
                    .navigationBarHidden(true)
                }

            }
            .background(
                AngularGradient(
                    gradient: Gradient(colors: [
                        Color(hue: 0.7, saturation: 0.8, brightness: 0.4),
                        Color(hue: 0.65, saturation: 0.9, brightness: 0.3),
                        Color(hue: 0.6, saturation: 0.85, brightness: 0.35),
                        Color(hue: 0.7, saturation: 0.8, brightness: 0.4)
                    ]),
                    center: .center
                )
                .ignoresSafeArea()
            )
        }
    }

    // Start Timer
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            moveToNextPage()
        }
    }

    // Stop Timer
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    // Restart Timer
    private func restartTimer() {
        stopTimer()
        startTimer()
    }

    // Move to the Next Page
    private func moveToNextPage() {
        withAnimation {
            currentPage = (currentPage + 1) % 3 // Cycle through pages
        }
    }
}

#Preview {
    WelcomeView()
}
