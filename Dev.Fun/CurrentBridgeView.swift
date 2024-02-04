//import SwiftUI
//
//class NavigationManager: ObservableObject {
//    @Published var isNavigating = false
//    @Published var destination: AnyView? = nil
//}
//
//struct CurrentBridgeView: View {
//    let images = ["bridg1", "bridg2"]
//    let destinations: [AnyView] = [AnyView(BattleGame()), AnyView(FindYourPath())]
//    @State private var currentIndex: Int = 0
//    @State private var dragOffset: CGFloat = 0
//    @ObservedObject private var navigationManager = NavigationManager()
//    
//    var body: some View {
//        VStack {
//            ZStack {
//                ForEach(0..<images.count, id: \.self) { index in
//                    VStack {
//                        ZStack(alignment: .bottom) {
//                            Rectangle()
//                                .foregroundColor(.clear)
//                                .frame(width: 396, height: 455)
//                                .background(
//                                    Image(images[index])
//                                        .resizable()
//                                        .aspectRatio(contentMode: .fit)
//                                        .clipped()
//                                        .cornerRadius(25)
//                                )
//                                .onTapGesture {
//                                    self.navigationManager.isNavigating = true
//                                    self.navigationManager.destination = self.destinations[index]
//                                }
//                        }
//                    }
//                    .opacity(currentIndex == index ? 1.0 : 0.5)
//                    .scaleEffect(currentIndex == index - 3 ? 0.1 : 1.0)
//                    .offset(x: CGFloat(index - currentIndex) * 360 + dragOffset, y: -38)
//                }
//                
//                // Page Indicator
//                VStack(spacing: 75) {
//                    HStack(spacing: 10) {
//                        ForEach(0..<images.count, id: \.self) { index in
//                            Circle()
//                                .fill(Color("IndicatorColor"))
//                                .frame(width: 10, height: 10)
//                                .opacity(currentIndex == index ? 1.0 : 0.5)
//                        }
//                    }
//                    Image("devFun")
//                }
//                .padding(.top, 550)
//            }
//        }
//            .gesture(
//                DragGesture()
//                    .onChanged { value in
//                        dragOffset = value.translation.width
//                    }
//                    .onEnded { value in
//                        let threshold: CGFloat = 50
//                        if value.translation.width > threshold {
//                            withAnimation {
//                                currentIndex = max(0, currentIndex - 1)
//                            }
//                        } else if value.translation.width < -threshold {
//                            withAnimation {
//                                currentIndex = min(images.count - 1, currentIndex + 1)
//                            }
//                        } else {
//                            withAnimation {
//                                dragOffset = 0
//                            }
//                        }
//                    }
//            )
//            .background(
//                NavigationLink(destination: navigationManager.destination, isActive: $navigationManager.isNavigating) {
//                    EmptyView()
//                }
//                    .hidden()
//            )
//        
//    }
//    
//}
//struct CurrentBridgeView_Previews: PreviewProvider {
//    static var previews: some View {
//        CurrentBridgeView()
//    }
//}
import SwiftUI

struct CurrentBridgeView: View {
let images = ["bridg1","bridg2"]
let destinations: [AnyView] = [AnyView(BattleGame()), AnyView(FindYourPath())]
@State private var currentIndex: Int = 0
@GestureState private var dragOffset: CGFloat = 0

var body: some View {
    VStack {
        ZStack {
            ForEach(0..<images.count, id: \.self) { index in
                VStack {
                    ZStack(alignment: .bottom) {
                        NavigationLink(destination: destinations[index].navigationBarBackButtonHidden(true)) {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 346, height: 455)
                                .background(
                                    Image(images[index])
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .clipped()
                                        .cornerRadius(25))
                        }
                    }
                }
                .opacity(currentIndex == index ? 1.0 : 0.5)
                .scaleEffect(currentIndex == index - 3 ? 0.1 : 1.0)
                .offset(x: CGFloat(index - currentIndex) * 360 + dragOffset, y: -30)
            }

            // Page Indicator
            VStack(spacing: 75) {
                HStack(spacing: 10) {
                    ForEach(0..<images.count, id: \.self) { index in
                        Circle()
                            .fill(Color(red: 0, green: 0.00, blue: 0.00))
                            .frame(width: 10, height: 10)
                            .opacity(currentIndex == index ? 1.0 : 0.5)
                    }
                }
                Image("devFun")
            }
            .padding(.top, 550)
        }
        .gesture(
            DragGesture()
                .onEnded({ value in
                    let threshold: CGFloat = 1
                    if value.translation.width > threshold {
                        withAnimation {
                            currentIndex = max(0, currentIndex - 1)
                        }
                    } else if value.translation.width < -threshold {
                        withAnimation {
                            currentIndex = min(images.count - 1, currentIndex + 1)
                        }
                    }
                })
        )
    }
}
}
#Preview {
CurrentBridgeView()
}
