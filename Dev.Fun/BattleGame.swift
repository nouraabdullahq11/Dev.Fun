//
//  BattleGame.swift
//  DevFun
//
//  Created by Abeer Alyaeesh on 10/07/1445 AH.
//

import SwiftUI


struct BattleGame: View {
    var body: some View {
        NavigationView {
            
            ZStack {
                Color(hex:"0088CA")
                    .ignoresSafeArea()
                VStack (alignment: .leading, spacing: 0){
                    Text("\nBrainiac\nBattle ")
                        .font(
                            Font.custom("SF Pro", size: 46)
                                .weight(.bold)
                        )
                        .kerning(0.65566)
                        .foregroundColor(.white)
                    
                    Text("Let's put our knowledge to the test and have a little group quiz about what we learned in our last sessions. Fire away with your questions!\n")
                        .font(Font.custom("SF Pro", size: 12))
                        .kerning(0.27692)
                        .foregroundColor(.white)
                    
                        .frame(width: 305, alignment: .topLeading)
                    ZStack{
                        
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 190, height: 50)
                            .background(.white)
                            .cornerRadius(12)
                        
                        
                        HStack{
                            NavigationLink(destination: Rock().navigationBarBackButtonHidden(true)){
                                
                                Text("Play")
                                    .foregroundColor(.black)
                                    .bold()
                                    .padding()
                                    .background(
                                        Rectangle()
                                            .foregroundColor(.clear)
                                            .frame(width: 172, height: 50)
                                        //.background(Color.white)
                                            .cornerRadius(12))
                                
                                
                                Image("Path")
                                    .resizable()
                                    .frame(width: 20,height: 15)
                                
                            }}
                        
                    }
                    .padding(.trailing,40)
                    
                }
                .padding(.leading,40)
                .padding(.trailing,48)
                .padding(.top, 406)
                .padding(.bottom,140)
                
                
            }.frame(width: 393, height: 852)
                .background(.white)
            
            
        }
        
    }}
    struct BattleGameView_Previews: PreviewProvider {
        static var previews: some View {
            BattleGame()
        }
        
    }
    

    
    
    extension Color {
        init(hex: String) {
            var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
            hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
            
            var rgb: UInt64 = 0
            
            Scanner(string: hexSanitized).scanHexInt64(&rgb)
            
            let red = Double((rgb & 0xFF0000) >> 16) / 255.0
            let green = Double((rgb & 0x00FF00) >> 8) / 255.0
            let blue = Double(rgb & 0x0000FF) / 255.0
            
            self.init(red: red, green: green, blue: blue)
        }
    }


