import SwiftUI
import FirebaseFirestore
import Combine
@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var userID: String = ""
    @Published var userName: String = ""
    static let shared = SettingsViewModel()
    init() { }
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

    func signOut() async throws {
        do {
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
                
                // Password updated successfully
                presentationMode.wrappedValue.dismiss()
                
                // Set showPasswordChangedAlert to true after successful password change
                showPasswordChangedAlert = true
            } catch {
                print(error)
            }
        }
         
    @State private var showAlert: Bool = false
      @State private var alertMessage: String = ""
      @State private var showSuccessAlert: Bool = false
    @State private var Title: String = ""
    @State private var isChangePasswordViewPresented: Bool = false

    
    var body: some View {
        NavigationView {
            VStack {
                VStack(alignment: .leading) {
                    Text("Reset your Password")
                    SecureField("New Password", text: $newPassword)
                        .textContentType(.newPassword)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.black, lineWidth: 1)
                        )
                }.padding()

                VStack(alignment: .leading) {
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
                                    if !isChangePasswordViewPresented && newPassword == confirmPassword && isPasswordValid(newPassword) {
                                        Task {
                                            do {
                                                try await updatePassword(email: "user@example.com", newPassword: newPassword)
                                                
                                                // Set the flag to indicate that the view has been presented
                                                isChangePasswordViewPresented = true

                                                showAlert = true
                                                alertMessage = "Password successfully updated!"
                                                Title = "Done"
                                            } catch {
                                                showAlert = true
                                                alertMessage = "Error updating password: \(error)"
                                                Title = "Error"
                                            }
                                        }
                                    } else if newPassword != confirmPassword {
                                        // Handle password mismatch error
                                        showAlert = true
                                        alertMessage = "Error updating password: Passwords do not match."
                                        Title = "Error"
                                    } else {
                                        // Handle other password validity errors
                                        showAlert = true
                                        alertMessage = "Password does not meet complexity requirements."
                                        Title = "Error"
                                    }
                                }
                                .padding()
                                .alert(isPresented: $showAlert) {
                                    Alert(
                                        title: Text(Title),
                                        message: Text(alertMessage),
                                        dismissButton: .default(Text("OK")) {
                                            // If the password change was successful, navigate to ContentView
                                            if Title == "Done" {
                                                showSignInView = true
                                            }
                                        }
                                    )
                                }


//                Spacer()
                Text("User ID: \(settingsViewModel.userID)")
                Text("User Name: \(settingsViewModel.userName)")

//                Button("Log out") {
//                    Task {
//                        do {
//                            try await settingsViewModel.signOut()
//                            showSignInView = true
//                        } catch {
//                            print(error)
//                        }
//                    }
//                }
            }
            .navigationTitle("Change Password")
            .onAppear {
                settingsViewModel.fetchUserInfo()
            }
        }
    }
    
    
    func isPasswordValid(_ password: String) -> Bool {
        return hasUppercaseLetter(password) && hasDigit(password) && hasSpecialCharacter(password) && password.count >= 6
    }

    func hasUppercaseLetter(_ password: String) -> Bool {
        let uppercaseLetterRegex = ".*[A-Z]+.*"
        return NSPredicate(format: "SELF MATCHES %@", uppercaseLetterRegex).evaluate(with: password)
    }

    func hasDigit(_ password: String) -> Bool {
        let digitRegex = ".*[0-9]+.*"
        return NSPredicate(format: "SELF MATCHES %@", digitRegex).evaluate(with: password)
    }

    func hasSpecialCharacter(_ password: String) -> Bool {
        let specialCharacterRegex = ".*[^A-Za-z0-9]+.*"
        return NSPredicate(format: "SELF MATCHES %@", specialCharacterRegex).evaluate(with: password)
    }
    
    var alertTitle: String {
          return showAlert ? "Error" : "Success"
      }
  
    
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(showSignInView: .constant(false))
    }
}
