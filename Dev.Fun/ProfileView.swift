//  Profile.swift
//  DevFun
//
//  Created by Abeer Alyaeesh on 16/07/1445 AH.
//
import SwiftUI

struct Team {
    let name: String
    let teammates: [Teammate]
}

struct Teammate {
    let memojiImageName: String // Image asset name for Memoji
}

struct TeammatesView: View {
    let team: Team
    @State private var isTeamNameTapped = false

    var body: some View {
        VStack {
            HStack {
                Text("Teammates in \(team.name):")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .center)
                    .foregroundColor(isTeamNameTapped ? Color.white : Color.primary)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(isTeamNameTapped ? Color(red: 0, green: 0.53, blue: 0.79) : Color.clear)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.primary, lineWidth: 1) // Add a border for visual connection
                            )
                    )
                    .onTapGesture {
                        withAnimation {
                            isTeamNameTapped.toggle()
                        }
                    }
            }

            if isTeamNameTapped {
                Divider()

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(team.teammates, id: \.memojiImageName) { teammate in
                            ZStack {
                                Circle()
                                    .foregroundColor(Color.appleThemeRandom())
                                    .frame(width: 60, height: 60) // Adjust the size of the circle
                                    .padding()

                                Image(teammate.memojiImageName)
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .frame(width: 60, height: 60) // Adjust the size of the image
                                    .padding()
                            }
                        }
                    }
                }
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(.systemBackground)))
                .cornerRadius(8)
                .shadow(radius: 4)
                .padding()
                .fixedSize() // Ensure fixed size for stable layout
            }
        }
    }
}

struct ProfileView: View {
    @StateObject private var settingsViewModel = SettingsViewModel.shared // Use the shared instance
 

//     @State private var showChangePasswordView = false
    // @StateObject private var viewModel = SettingsViewModel()
    @State private var profilePicture: Image = Image(systemName: "person.circle")
    @State private var showImagePicker: Bool = false
    @State private var name: String = "John Doe"
    @State private var bio: String = "I love SwiftUI!"
    @State private var isEditingProfile: Bool = false
    @State private var newName: String = ""
    @State private var newBio: String = ""
    @State private var isSheetPresented = false
    
    let teams: [Team] = [
        Team(name: "Team A", teammates: [
            Teammate(memojiImageName: "john_memoji"),
            Teammate(memojiImageName: "jane_memoji"),
            Teammate(memojiImageName: "bob_memoji"),
        ]),
        Team(name: "Team B", teammates: [
            Teammate(memojiImageName: "alice_memoji"),
            Teammate(memojiImageName: "charlie_memoji"),
            Teammate(memojiImageName: "david_memoji"),
        ]),
        Team(name: "Team v", teammates: [
            Teammate(memojiImageName: "alice_memoji"),
            Teammate(memojiImageName: "charlie_memoji"),
            Teammate(memojiImageName: "david_memoji"),
        ]),
    ]
    var body: some View {
        NavigationView {
            VStack {
                Button("Log out") {
                    Task {
                        do {
                            try await settingsViewModel.signOut()
                            RootView().onAppear()
                           
                        } catch {
                            print(error)
                        }
                    }
                }
                profilePicture
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(Color.gray, lineWidth: 2)
                            .overlay(
                                Button(action: {
                                    isEditingProfile = true
                                }) {
                                    Image(systemName: "pencil")
                                        .font(.system(size: 20))
                                        .padding(8)
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .clipShape(Circle())
                                }
                                    .offset(x: 50, y: 50)
                                    .opacity(isEditingProfile ? 0 : 1)
                            )
                    )
                    .onTapGesture {
                        self.showImagePicker = true
                    }.sheet(isPresented: $isEditingProfile) {
                        EditProfileView(name: $name, bio: $bio, profilePicture: $profilePicture)
                    }
//                Text(name)
                Text(settingsViewModel.userName)
                    .font(.title)
                    .padding()
                
//                Text(bio)
                Text("Front-end Devolper intrested in Arts and Craft")
                    .padding()
            
                ForEach(teams, id: \.name) { team in
                    TeammatesView(team: team)
                        .padding()
                }
                
                
                Button("Show Sheet") {
                              isSheetPresented.toggle()
                          }
                          .sheet(isPresented: $isSheetPresented) {
                              // Embed the sheet content in a NavigationView
                              NavigationView {
                                  SettingsView(showSignInView: .constant(false))
                              }
                          }
                
                
            }
            .navigationBarTitleDisplayMode(.inline)

        }
    }
}

struct EditProfileView: View {
    @Binding var name: String
    @Binding var bio: String
    @Binding var profilePicture: Image
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedImage: Image?
    @State private var showImagePicker: Bool = false

    var body: some View {
        NavigationView {
            VStack {
                profilePicture
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 150, height: 150)
                    .clipShape(Circle())
                    .onTapGesture {
                        self.showImagePicker = true
                    }
                    .sheet(isPresented: $showImagePicker) {
                        ImagePickerView(selectedImage: $selectedImage)
                    }

                TextField("Name", text: $name)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                TextField("Bio", text: $bio)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())

                Button(action: {
                    if let selectedImage = selectedImage {
                        profilePicture = selectedImage
                    }
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save Changes")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationBarTitle("Edit Profile")
        }
    }
}

// Add this ImagePickerView struct at the end of your existing code
struct ImagePickerView: UIViewControllerRepresentable {
    @Binding var selectedImage: Image?

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        @Binding var selectedImage: Image?

        init(selectedImage: Binding<Image?>) {
            _selectedImage = selectedImage
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                selectedImage = Image(uiImage: uiImage)
            }

            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(selectedImage: $selectedImage)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePickerView>) -> UIViewController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<ImagePickerView>) {
        // Update UI if needed
    }
}

extension Color {
    static func appleThemeRandom() -> Color {
        let appleColors: [Color] = [.red, .green, .blue, .orange, .yellow, .purple, .pink, .indigo]
        return appleColors.randomElement() ?? .gray
    }
}

struct HomeView: View {
    var body: some View {
        Text("Home View")
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
