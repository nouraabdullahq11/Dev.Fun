//
//  SigninEmailView.swift
//  Dev.Fun
//
//  Created by Noura Alqahtani on 25/01/2024.
//
import SwiftUI

@MainActor
final class SigninEmailViewModel: ObservableObject{
    
    @Published var email = ""
    @Published var password = ""
    @Published var firstName = ""  // New property for capturing the user's name
    func signIn() async throws {
            guard !email.isEmpty, !password.isEmpty else {
                print("No email or password found.")
                return
            }

            try await AuthenticationManager.shared.signInUser(email: email, password: password)
            updateUserInfo()
        }

        func signUp() async throws {
            guard !email.isEmpty, !password.isEmpty, !firstName.isEmpty else {
                print("Email, password, or name is missing.")
                return
            }

            try await AuthenticationManager.shared.createUser(email: email, password: password, firstName: firstName)
            updateUserInfo()
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

    
    func restPassword() async throws {
        let authUser = try await AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else{
            throw URLError(.fileDoesNotExist)
        }
        
        try await AuthenticationManager.shared.restPassword(email: email)
    }
    
}


struct SigninEmailView: View {
    
    
    @StateObject private var viewModel = SigninEmailViewModel()
    @Binding var showSignInView: Bool
    /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// /// ///
    ///
    ///
    /// /
    ///
    //
    @State private var isShowingForgetPasswordSheet = false
       @State private var resetPasswordEmail = ""
       @State private var isResetPasswordSuccessAlertPresented = false
    
    var body: some View {
        VStack{
            VStack(alignment: .leading){
                TextField("Name...", text: $viewModel.firstName)  // Added TextField for capturing the user's name
                                .padding()
                                .background(Color.gray.opacity(0.4))
                                .cornerRadius(10)
                      Text("Learner Email:")
                TextField("yourName23 @ twq.idserver.net", text: $viewModel.email )
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                          .overlay(
                          RoundedRectangle(cornerRadius: 10)
                          .stroke(.black, lineWidth: 1)
                          )
                  }
                  .padding()
        
            VStack(alignment: .leading){
                Text("One-time Password:")
                SecureField("Default Passcode...", text: $viewModel.password )
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .overlay(
                    RoundedRectangle(cornerRadius: 10)
                    .stroke(.black, lineWidth: 1)
                    )
            }                    .padding()
            Button {
                Task{
                    do{
                        try await  viewModel.signIn()
                        showSignInView = false
                        return
                    }catch {
                        print(error)
                    }
                }
            }label: {
                
                Text("Sign In")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 40)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .background(Color.black)
                    .cornerRadius(10)
            }.padding()
            
            Button {
                Task{
                    do{
                        try await  viewModel.signUp()
                        showSignInView = false
                        return
                    }catch {
                        print(error)
                    }
                    
//                    do{
//                        try await  viewModel.signIn()
//                        showSignInView = false
//                        return
//                    }catch {
//                        print(error)
//                    }
                }
            }label: {
                
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
            Button {
                            isShowingForgetPasswordSheet = true
                        } label: {
                            Text("Forget Password?")
                                .font(.headline)
                        }
                        .sheet(isPresented: $isShowingForgetPasswordSheet) {
                            ForgetPasswordSheet(isPresented: $isShowingForgetPasswordSheet, resetPasswordEmail: $resetPasswordEmail, onResetPasswordSuccess: {
                                isResetPasswordSuccessAlertPresented = true
                            })
                        }
                        .alert(isPresented: $isResetPasswordSuccessAlertPresented) {
                            Alert(
                                title: Text("Success"),
                                message: Text("Password reset email sent successfully."),
                                dismissButton: .default(Text("OK"))
                            )
                        }
            
        }
        .padding()
        .navigationTitle("Welcome 👋")
    }
}

struct ForgetPasswordSheet: View {
    @Binding var isPresented: Bool
    @Binding var resetPasswordEmail: String
    var onResetPasswordSuccess: () -> Void

    @State private var isResetPasswordSuccessAlertPresented = false

    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your email", text: $resetPasswordEmail)
                    .padding()
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)

                Button {
                    Task {
                        do {
                            try await AuthenticationManager.shared.restPassword(email: resetPasswordEmail)
                            onResetPasswordSuccess()
                            isResetPasswordSuccessAlertPresented = true
                        } catch {
                            print(error)
                            // Handle error appropriately (e.g., show error alert)
                        }
                    }
                } label: {
                    Text("Submit")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 55)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Forgot Password")
            .alert(isPresented: $isResetPasswordSuccessAlertPresented) {
                Alert(
                    title: Text("Success"),
                    message: Text("Password reset email sent successfully."),
                    dismissButton: .default(Text("OK")) {
                        isPresented = false
                    }
                )
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Close") {
                        isPresented = false
                    }
                }
            }
        }
    }
}

struct SigninEmailView_Previews: PreviewProvider{
    static var previews: some View{
        
        NavigationStack{
            SigninEmailView(showSignInView: .constant(false))
        }
        
    }
    
}
