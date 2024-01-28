//
//  RootView.swift
//  Dev.Fun
//
//  Created by Noura Alqahtani on 25/01/2024.
//


import SwiftUI
//////////////////
struct RootView: View {
    @State private var showSignInView: Bool = false

    var body: some View {
        ZStack {
            NavigationStack {
                SettingsView(showSignInView: $showSignInView)
            }
        }
        .task {
            do {
                _ = try await AuthenticationManager.shared.getAuthenticatedUser()
                // If no error is thrown, it means there is an authenticated user
                self.showSignInView = false
            } catch {
                // Handle any errors that might occur during the asynchronous operation
                // In this case, an error means no authenticated user, so set showSignInView to true
                self.showSignInView = true
                print("Error fetching authenticated user: \(error)")
            }
        }
        .fullScreenCover(isPresented: $showSignInView) {
            NavigationStack {
                AuthenticationView(showSignInView: $showSignInView)
            }
        }
    }
}


#Preview {
    RootView()
}
