//
//  AuthenticationManager.swift
//  Dev.Fun
//
//  Created by Noura Alqahtani on 25/01/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct authDataResultModel{
    let uid: String
        let email: String?
        let photoUrl: String?
        let firstName: String?  // Updated property for user's name
        
        init(user: User, firstName: String? = nil) {
            self.uid = user.uid
            self.email = user.email
            self.photoUrl = user.photoURL?.absoluteString
            self.firstName = firstName
        }
}


final class AuthenticationManager{
    static let shared = AuthenticationManager()
    private init () { }
    
    private let firestore = Firestore.firestore()

       private func saveUserData(uid: String, name: String) {
           let userRef = firestore.collection("users").document(uid)

           // Create a data dictionary with user information
           let userData: [String: Any] = [
               "uid": uid,
               "name": name
               // Add other user data if needed
           ]

           // Set the data in the Firestore document
           userRef.setData(userData) { error in
               if let error = error {
                   print("Error saving user data: \(error)")
               } else {
                   print("User data saved successfully")
               }
           }
       }

    func getAuthenticatedUser() async throws -> authDataResultModel {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }

        let userDocRef = firestore.collection("users").document(user.uid)

        do {
            let userDataSnapshot = try await userDocRef.getDocument()
            
            guard let data = userDataSnapshot.data(),
                  let firstName = data["name"] as? String else {
                // Handle the case where the user's name is not found in Firestore
                throw URLError(.badServerResponse)
            }
            
            return authDataResultModel(user: user, firstName: firstName)
        } catch {
            // Handle any errors that might occur during the Firestore document fetch
            throw error
        }
    }

    
    @discardableResult
    func signInUser(email: String, password: String)async throws -> authDataResultModel{
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
           return authDataResultModel(user: authDataResult.user)
    }
    
    func updatePassword(email: String, newPassword: String) async throws {
           guard let currentUser = Auth.auth().currentUser else {
               throw URLError(.badServerResponse)
           }
           
           try await currentUser.updatePassword(to: newPassword)
       }
    
    func restPassword(email: String) async throws {
       try await Auth.auth().sendPasswordReset(withEmail: email)
    }
//    @discardableResult
//    func createUser(email: String, password: String)async throws -> authDataResultModel{
//     let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
//        return authDataResultModel(user: authDataResult.user)
//    }
//
    @discardableResult
    func createUser(email: String, password: String, firstName: String) async throws -> authDataResultModel {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
        
        // Save user's name along with user ID
        saveUserData(uid: authDataResult.user.uid, name: firstName)
        
        return authDataResultModel(user: authDataResult.user, firstName: firstName)
    }

        // Additional method to save user's name (replace with your actual implementation)
//         func saveUserData(uid: String, name: String) {
//            // Implement your logic to save the user's name with the user ID
//            // This could involve using a database or another storage mechanism
//            // For demonstration purposes, we'll print the information here
//            print("User ID: \(uid), Name: \(name) - User data saved successfully")
//        }

    
    func signOut() throws {
       try Auth.auth().signOut()
    }
    
  
    
}


