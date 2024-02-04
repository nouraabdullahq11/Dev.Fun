//
//  AuthenticationView.swift
//  Dev.Fun
//
//  Created by Noura Alqahtani on 25/01/2024.
//


import SwiftUI

struct AuthenticationView: View {
    @Binding var showSignInView: Bool
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        VStack(spacing: 47){
            VStack(spacing: 47){
                Image("devFun")
                    .resizable()
                    .frame(width: 194.45946, height: 46.39949)
            }
            NavigationLink{
                SigninEmailView(showSignInView: $showSignInView).navigationBarBackButtonHidden(true)
            } label: {
                
                Text("Sign in with Learner Email")
                    .font(.headline)
                   
                    .frame(height: 40)
                    .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
//.background(Color.black)
                    .background(
                                        colorScheme == .dark ? Color.white : Color.black
                                    )
                                    .foregroundColor(
                                        colorScheme == .dark ? Color.black : Color.white
                                    )
                    .cornerRadius(15)
                
            }
            .padding()
         
        }
    }
}
struct AuthenticationView_Previews: PreviewProvider{
    static var previews: some View{
        
        NavigationStack{
            AuthenticationView(showSignInView: .constant(false))
        }
        
    }
    
}
