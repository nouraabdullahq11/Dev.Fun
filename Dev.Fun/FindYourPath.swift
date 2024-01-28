//
//  FindYourPath.swift
//  Dev.Fun
//
import SwiftUI

struct FindYourPath: View {

    var body: some View {
       NavigationView{
        ZStack{
            
            Color(.black).ignoresSafeArea()
            //            .background(Color.black.ignoresSafeArea(.all))
            
            VStack(alignment: .leading, spacing: 0) {
                Text("\nFind your\nPath ")
                    .font(
                        Font.custom("SF Pro", size: 46)
                            .weight(.bold)
                    )
                    .kerning(0.65566)
                    .foregroundColor(.white)
                
                Text("This quiz designed to help you discover which path as devolper suits you the most !\n")
                    .font(Font.custom("SF Pro", size: 12))
                    .kerning(0.27692)
                    .foregroundColor(.white)
                
                    .frame(width: 305, alignment: .topLeading)
                
                ZStack{
                    NavigationLink (destination: PathWays().navigationBarBackButtonHidden(true)) {
                        
                        
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 172, height: 50)
                            .background(.white)
                        
                            .cornerRadius(12)
                        
                    }
                    HStack{
                        Text("Play")
                            .font(
                                Font.custom("Roboto", size: 21)
                                    .weight(.bold)
                            )
                            .kerning(0.48462)
                            .foregroundColor(Color(red: 0.17, green: 0.18, blue: 0.2))
                        
                        
                        Image("Path")
                            .resizable()
                            .frame(width: 20, height: 15)
                        
                    }
                }
            }
            .padding(.leading, 40)
            .padding(.trailing, 48)
            .padding(.top, 406)
            .padding(.bottom, 140)
            .background(.black)
            
            
            
        }.frame(width: 393, height: 852)
            .background(.white)
    }  }
}

struct FindYourPath_Previews: PreviewProvider {
    static var previews: some View {
        FindYourPath()
    }
}
