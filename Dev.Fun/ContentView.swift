//
//  ContentView.swift
//  DevFun App
//
//  Created by SHUAA on 15.1.2024.
//

import SwiftUI
import SwiftData
struct ContentView: View {
    struct ImageSet {
        let unlockedImages: [String]
        let lockedImages: [String]
        let switchDate: Date
    }
    @StateObject private var settingsViewModel = SettingsViewModel.shared // Use the shared instance
    @State private var isViewShown: Bool = false
    @Environment(\.modelContext) private var modelContext
    let unlockedImages = ["scrollunlock1", "scrollunlock2", "scrollunlock3", "scrollunlock4", "scrollunlock5"]
    let currintImages = ["currentScroll1","currentScroll2","currentScroll3","currentScroll4","currentScroll5"]
    let lockedImages = ["scrollLock1", "scrollLock2", "scrollLock3", "scrollLock4", "scrollLock5"]
    let discribtion = ["Preload", "Bridge 1", "Bridge 2", "Bridge 3", "Bridge 4"]
    @State private var imagesToDisplay: [String] = []

    @Query private var items: [Item]
    @State private var scale: CGFloat = 1
    @State private var color: Color = .white
    var body: some View {
        NavigationView{
            VStack{
                Text("✨ Good Job \(settingsViewModel.userName) ✨")
                    .font(
                        Font.custom("SF Pro", size: 13)
                            .weight(.bold))
                // Adjust font size
                    .foregroundColor(color)
                    .scaleEffect(scale)
                    .frame(width: 346, height: 62, alignment: .center)
                    .background(Color(red: 0.04, green: 0.04, blue: 0.04))                .cornerRadius(15)
                    .onAppear {
                        withAnimation(Animation.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                            scale = 1.2
                            color = .white
                        }}
                NavigationLink(destination: CurrentBridgeView()){
                    ZStack(alignment: .init(horizontal: .center, vertical: .bottom)){
                        Image ("Card2")
                            .cornerRadius(33)
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 346, height: 299)
                            .background(
                                LinearGradient(
                                    stops: [
                                        Gradient.Stop(color: Color(red: 0.48, green: 0.81, blue: 1).opacity(0.89), location: 0.00),
                                        Gradient.Stop(color: Color(red: 0.48, green: 0.81, blue: 1).opacity(0), location: 1.00),
                                    ],
                                    startPoint: UnitPoint(x: 0.5, y: 0),
                                    endPoint: UnitPoint(x: 0.5, y: 1)
                                )
                            )
                            .cornerRadius(33)
                            .offset(x:0)
                            .offset(y:-76)
                        
                        HStack{
                            Text("Current Bridge")
                                .font(
                                    Font.custom("SF Pro", size: 28)
                                        .weight(.bold)
                                )
                            Image(systemName: "arrow.right.circle")
                        }
                        .background(
                            (Color.black))
                        .cornerRadius(17)
                        .frame(width: 346, height: 100)
                        .foregroundColor(.white)
                        
                    }
                }
                HStack{
                    Text("Academy Arcade")
                        .font(.system(size: 25))
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                }.padding(.trailing,150)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(imagesToDisplay.indices, id: \.self) { number in
                            VStack {
                                Image("\(imagesToDisplay[number])")
                                    .resizable()
                                    .clipShape(RoundedRectangle(cornerRadius: 24.0))
                                    .frame(width: 222, height: 124)
                                
                                Text("\(discribtion[number])")
                                    .font(Font.custom("SF Pro Text", size: 15)
                                        .weight(.semibold))
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .onAppear {
                    // Initial set of images when the view appears
                    imagesToDisplay = getImagesToDisplay()
                }
            }
            .navigationBarItems(
                leading: HStack {
                    Text("Welcome Back \(settingsViewModel.userName)")
                        .font(.system(size: 25))
                        .fontWeight(.semibold)
                        .foregroundColor(.black)
                        .offset(y:25)
                        .offset(x:15)
                },
                trailing: HStack {
                    NavigationLink(destination: ProfileView()){
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.black)
                            .offset(y:25)
                            .offset(x:-15)
                        
                    }
                })
        }
    }
func getImagesToDisplay() -> [String] {
    let currentDate = Date()

    // Set the switching dates for each image
    let switchDates: [Date] = [
        createDate(year: 2024, month: 1, day: 23, hour: 23, minute: 00, second: 0),
        createDate(year: 2024, month: 1, day: 23, hour: 23, minute: 00, second: 0),
        createDate(year: 2024, month: 1, day: 23, hour: 23, minute: 00, second: 0),
        createDate(year: 2024, month: 1, day: 23, hour: 23, minute: 00, second: 0),
        createDate(year: 2024, month: 2, day: 25, hour: 10, minute: 16, second: 0)
    ]
    // Find the index based on the current date
    let index = switchDates.firstIndex { currentDate < $0 } ?? switchDates.count

    // Replace one image at a time based on the current date
    var updatedImages = lockedImages
    for i in 0..<(lockedImages.count) {
        if i < index {
            updatedImages[i] = unlockedImages[i]
        } else if i == index {
            updatedImages[i] = currintImages[i]
        }
    }

    return updatedImages
}
func createDate(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Date {
    var components = DateComponents()
    components.year = year
    components.month = month
    components.day = day
    components.hour = hour
    components.minute = minute
    components.second = second

    guard let date = Calendar.current.date(from: components) else {
        fatalError("Failed to create a valid date.")
    }

    return date
}
}
#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
