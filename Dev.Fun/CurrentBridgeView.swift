

import SwiftUI

struct CurrentBridgeView: View {
    let images = ["bridg1", "bridg2"]
    let destinations: [AnyView] = [AnyView(BattleGame()), AnyView(FindYourPath())]
    @State private var currentIndex: Int = 0
    @State private var totalDragOffset: CGFloat = 0
    @State private var isNavigating = false

    var body: some View {
        VStack {
            ZStack {
                ForEach(0..<images.count, id: \.self) { index in
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 346, height: 455)
                        .background(
                            Image(images[index])
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipped()
                                .cornerRadius(25)
                        )
                        .opacity(currentIndex == index ? 1.0 : 0.5)
                        .scaleEffect(currentIndex == index - 3 ? 0.1 : 1.0)
                        .offset(x: CGFloat(index - currentIndex) * 360 + totalDragOffset, y: -30)
                        .gesture(
                            TapGesture()
                                .onEnded {
                                    // Handle tap action if needed
                                }
                        )
                }

                // Page Indicator
                VStack(spacing: 75) {
                    HStack(spacing: 10) {
                        ForEach(0..<images.count, id: \.self) { index in
                            Circle()
                                .fill(Color("IndicatorColor"))
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
                    .onChanged { value in
                        totalDragOffset = value.translation.width
                    }
                    .onEnded { value in
                        let threshold: CGFloat = 50
                        if value.translation.width > threshold {
                            withAnimation {
                                currentIndex = max(0, currentIndex - 1)
                                isNavigating = true
                            }
                        } else if value.translation.width < -threshold {
                            withAnimation {
                                currentIndex = min(images.count - 1, currentIndex + 1)
                                isNavigating = true
                            }
                        } else {
                            withAnimation {
                                totalDragOffset = 0
                            }
                        }
                    }
            )
            .background(
                NavigationLink(
                    destination: isNavigating ? destinations[currentIndex] : nil,
                    isActive: $isNavigating
                ) {
                    EmptyView()
                }
                .hidden()
            )
        }
    }
}

//
//    struct CurrentBridgeView_Previews: PreviewProvider {
//        static var previews: some View {
//            CurrentBridgeView()
//        }
//    }

#Preview {
    CurrentBridgeView()
}
