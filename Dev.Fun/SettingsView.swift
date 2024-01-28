//
//  SettingsView.swift
//  Dev.Fun
//
//  Created by Noura Alqahtani on 25/01/2024.
//


import SwiftUI

import FirebaseFirestore
/////////////////////////////
import Combine
@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var userID: String = ""
    @Published var userName: String = ""
    static let shared = SettingsViewModel()
        init() { }
    // Function to fetch user information
    func fetchUserInfo() {
           Task {
               do {
                   let authenticatedUser = try await AuthenticationManager.shared.getAuthenticatedUser()
                   userID = authenticatedUser.uid
                   userName = authenticatedUser.firstName ?? "N/A"
               } catch {
                   print("Error fetching authenticated user: \(error)")
               }
           }
       }


    func signOut() throws {
        do {
            // Print user information before signing out
            printUserInfo()

            try AuthenticationManager.shared.signOut()
        } catch {
            print(error)
        }
    }

    func updateUserInfo() {
            Task {
                do {
                    let authenticatedUser = try await AuthenticationManager.shared.getAuthenticatedUser()
                    SettingsViewModel.shared.userID = authenticatedUser.uid
                    SettingsViewModel.shared.userName = authenticatedUser.firstName ?? "N/A"
                } catch {
                    print("Error fetching authenticated user: \(error)")
                }
            }
        }

    // Function to print user ID and name
    private func printUserInfo() {
        print("User ID: \(userID)")
        print("User Name: \(userName)")
    }
}

struct SettingsView: View {
    @StateObject private var settingsViewModel = SettingsViewModel.shared // Use the shared instance
    // @StateObject private var settingsViewModel = SettingsViewModel()

     @State private var showChangePasswordView = false
    // @StateObject private var viewModel = SettingsViewModel()
     @Binding var showSignInView: Bool
     @Environment(\.presentationMode) private var presentationMode
     @State private var newPassword = ""
     @State private var confirmPassword = ""
     @State private var showPasswordMismatchAlert = false
     @State private var showPasswordChangedAlert = false
     //@Binding var showChangePasswordView: Bool

    func updatePassword(email: String, newPassword: String) async throws {
            do {
                try await AuthenticationManager.shared.updatePassword(email: email, newPassword: newPassword)
                
                // Password updated successfully, now print user ID and name
              //  printUserInfo()
                
                presentationMode.wrappedValue.dismiss()
            } catch {
                print(error)
            }
        }
        
    
    var body: some View {
        NavigationView {
            
                VStack {
                    // Rest Password Section
                VStack(alignment: .leading){
                    Text("Rest your Password")
                    SecureField("New Password", text: $newPassword)
                        .textContentType(.newPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black, lineWidth: 1)
                        )
                }.padding()
                    VStack(alignment: .leading){
                        Text("Reenter Password")
                        SecureField("Confirm Password", text: $confirmPassword)
                            .textContentType(.newPassword)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.black, lineWidth: 1)
                            )
                        
                    }.padding()
                  
                    Button("Save") {
                        if newPassword == confirmPassword {
                            Task {
                                do {
                                    try await updatePassword(email: "user@example.com", newPassword: newPassword)
                                }
                                catch {
                                    print(error)
                                }
                            }
                        } else {
                            showPasswordMismatchAlert = true
                        }
                    }
                    .padding()
                    .alert(isPresented: $showPasswordChangedAlert) {
                        Alert(
                            title: Text("Password Mismatch"),
                            message: Text("Please make sure the new password and confirm password match."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                    .alert(isPresented: $showPasswordMismatchAlert) {
                        Alert(
                            title: Text("Password Mismatch"),
                            message: Text("Please make sure the new password and confirm password match."),
                            dismissButton: .default(Text("OK"))
                        )
                    }
                    
                    Spacer()
                    Text("User ID: \(settingsViewModel.userID)")
                               Text("User Name: \(settingsViewModel.userName)")
                    Button("Log out") {
                        Task {
                            do {
                                try settingsViewModel.signOut()
                                showSignInView = true
                            } catch {
                                print(error)
                            }
                        }
                    }
                }
                .navigationTitle("Change Password")
                .onAppear {
                                // Fetch user information including name when the view appears
                                settingsViewModel.fetchUserInfo()
                            }
            
           // List {
//                Button("Log out") {
//                    Task {
//                        do {
//                            try viewModel.signOut()
//                            showSignInView = true
//                        } catch {
//                            print(error)
//                        }
//                    }
//                }
//
//                Button("Change Password") {
//                    showChangePasswordView.toggle()
//                }
//            }
//            .navigationTitle("Settings")
//            .sheet(isPresented: $showChangePasswordView) {
//                ChangePasswordView(showChangePasswordView: $showChangePasswordView)
//            }
        }
    }
}

//struct ChangePasswordView: View {
//    @Environment(\.presentationMode) private var presentationMode
//    @State private var newPassword = ""
//    @State private var confirmPassword = ""
//    @State private var showPasswordMismatchAlert = false
//    @Binding var showChangePasswordView: Bool
//
//    func updatePassword(email: String, newPassword: String) async throws {
//        try await AuthenticationManager.shared.updatePassword(email: email, newPassword: newPassword)
//    }
//
//    var body: some View {
//        VStack {
//            SecureField("New Password", text: $newPassword)
//                .textContentType(.newPassword)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//
//            SecureField("Confirm Password", text: $confirmPassword)
//                .textContentType(.newPassword)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//
//            Button("Save") {
//                if newPassword == confirmPassword {
//                    Task {
//                        do {
//                            try await updatePassword(email: "user@example.com", newPassword: newPassword)
//                            presentationMode.wrappedValue.dismiss()
//                        } catch {
//                            print(error)
//                        }
//                    }
//                } else {
//                    showPasswordMismatchAlert = true
//                }
//            }
//            .padding()
//            .alert(isPresented: $showPasswordMismatchAlert) {
//                Alert(
//                    title: Text("Password Mismatch"),
//                    message: Text("Please make sure the new password and confirm password match."),
//                    dismissButton: .default(Text("OK"))
//                )
//            }
//
//            Spacer()
//        }
//        .navigationTitle("Change Password")
//    }
//}

// Preview code
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showSignInView: .constant(false))
    }
}
