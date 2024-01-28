//
//  RockView.swift
//  DevFun
//
//  Created by Abeer Alyaeesh on 12/07/1445 AH.
//

import SwiftUI
import UIKit

struct RockView: View {
    @State private var isPresented = false
    // To dismiss the view
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack{
                    VStack{
                        VStack{
//                            GIFView(name: "Animation - 1706170405159.gif")
                                           //.frame(width: 200, height: 200) /
                            Text("🚀")
                                .font(
                                    Font.custom("SF Pro", size: 200)
                                        .weight(.bold)
                                )
                            Text("You Rock! ")
                                .font(
                                    Font.custom("SF Pro", size: 46)
                                        .weight(.bold)
                                )
                                .foregroundColor(.white)
                    }
                }
                .navigationBarBackButtonHidden(true)
                .frame(width: 393, height: 852)
                .background(Color(hex: "0088CA").ignoresSafeArea())
                .toolbar{
                    ToolbarItem(placement: .navigationBarLeading){
                        Button(action: {
                            isPresented.toggle()
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .fullScreenCover(isPresented: $isPresented) {
                            ContentView()
                        }
                    }
                }
        }
        }
//    struct GIFView: UIViewRepresentable {
//        var name: String
//
//        func makeUIView(context: Context) -> UIView {
//            let uiView = UIView()
//            let gifImageView = UIImageView()
//            uiView.addSubview(gifImageView)
//
//            // Load and display the GIF
//            if let gifPath = Bundle.main.path(forResource: name, ofType: "gif"),
//               let gifData = try? Data(contentsOf: URL(fileURLWithPath: gifPath)),
//               let image = UIImage.gifImageWithData(gifData) {
//                gifImageView.image = image
//            }
//
//            return uiView
//        }
//
//        func updateUIView(_ uiView: UIView, context: Context) {
//            // Update logic if needed
//        }
//    }
//
//    #if DEBUG
//    struct ContentView_Previews: PreviewProvider {
//        static var previews: some View {
//            ContentView()
//        }
//    }
//    #endif
}


#Preview {
    RockView()
}
