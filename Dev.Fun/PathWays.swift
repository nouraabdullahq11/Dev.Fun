


import SwiftUI

struct PathWays: View {
    @State private var designPoints = 0
    @State private var frontendPoints = 0
    @State private var backendPoints = 0
    @State private var currentPage: Int = 1
    @State private var showingResult = false

    // Arrays of question texts for each category
    let designQuestions = [
        "Is designing user-friendly interfaces important to you?",
        "Do you enjoy the process of prototyping and testing designs?",
        "Are you interested in color theory, typography, and layout?",
        "Is working on brand identity and style guides important to you?",
        "Do you like conducting user research?"
    ]
    
    let frontendQuestions = [
        "Do you enjoy working with visual design and layouts?",
        "Are you familiar with responsive web design?",
        "Do you enjoy adding animations  and transitions to mobile apps or websites?",
        "Do you collaborate closely with designers to implement visual elements?",
        "Are you familiar with using tools like Webpack or Gulp?"
    ]
    
    let backendQuestions = [
        "Do you prefer programming logic over design?",
        "Is working with data structures appealing to you?",
        "Are you interested in network security and data protection?",
        "Do you feel confident about writing unit tests for your code?",
        "Is building and maintaining APIs a core part of your ideal job?"
    ]

    var body: some View {
        NavigationView {
            VStack {
                if !showingResult {
                    if currentPage <= 5 {
                        QuestionView(question: designQuestions[currentPage - 1], points: $designPoints, currentPage: $currentPage) {
                            currentPage += 1
                        }
                    } else if currentPage <= 10 {
                        QuestionView(question: frontendQuestions[currentPage - 6], points: $frontendPoints, currentPage: $currentPage) {
                            currentPage += 1
                        }
                    } else if currentPage <= 15 {
                        QuestionView(question: backendQuestions[currentPage - 11], points: $backendPoints, currentPage: $currentPage) {
                            currentPage += 1
                        }
                    } else {
                        ResultView(designPoints: designPoints, frontendPoints: frontendPoints, backendPoints: backendPoints) {
                            showingResult = false
                            currentPage = 1
                            designPoints = 0
                            frontendPoints = 0
                            backendPoints = 0
                        }
                        .navigationBarHidden(true)
                    }
                }
            }
        }
    }
}

struct QuestionView: View {
    var question: String
    @Binding var points: Int
    @Binding var currentPage: Int  // Add currentPage binding
    var nextPage: () -> Void   // Closure to handle navigation

    @State private var selectedAnswer: String = ""

    var isLastQuestion: Bool {
        return currentPage == 15
    }

    var isAnswerSelected: Bool {
        return !selectedAnswer.isEmpty
    }

    var body: some View {
        ZStack {
            
            VStack{
                VStack{
                    Text(question)
                        .font(.title)
                        .fontWeight(.bold)
                       // .kerning(0.65566)
                        .padding()
                        .padding(.bottom,200)
                }.padding(.leading,15)
                    .padding(.trailing, 10)
            }
            VStack(spacing: 20){
                AnswerButton(answer: "Yes", isSelected: selectedAnswer == "Yes") {
                    selectedAnswer = "Yes"
                }
                
                AnswerButton(answer: "No", isSelected: selectedAnswer == "No") {
                    selectedAnswer = "No"
                }
                
                AnswerButton(answer: "Sometimes", isSelected: selectedAnswer == "Sometimes") {
                    selectedAnswer = "Sometimes"
                }
            }.padding(.top,150)
       // }
        Spacer()
            .frame(width: 200.0, height: 200.0)
   //   ZStack{
        VStack{
            //  }
            if isLastQuestion {
                if isAnswerSelected {
                 
                    Button(action: {
                        
                        withAnimation {
                            nextPage()
                            
                        }
                    }, label: {
                        Text("See Result")
                            .foregroundColor(.blue)
                    })
              
                }
            }
       
            else {
                
                Button(action: {
                    guard isAnswerSelected else {
                        // Show an alert or handle the case where the user hasn't answered the current question
                        return
                    }
                    
                    updatePoints(selectedAnswer)
                    selectedAnswer = ""  // Reset selectedAnswer for the next question
                    nextPage()  // Use the closure to handle navigation
                }) {
                    Text("Next Question")
                        .foregroundColor(.blue)
                    // .padding(.bottom)
                }
                    
                }
            }.padding(.top,400)
       
      
        .onChange(of: selectedAnswer) { _ in
            if selectedAnswer == "Navigate" {
                nextPage()  // Use the closure to handle navigation
            }
        }
      }
    }
//}

    func updatePoints(_ answer: String) {
        switch answer {
        case "Yes":
            points += 2
        case "Sometimes":
            points += 1
        default:
            break
        }
    }
}


struct AnswerButton: View {
    var answer: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: {
            action()
        }) {
            Text(answer)
                .padding()
                .foregroundColor(isSelected ? .white : .black)
                .frame(width: 324, height: 45)
                .background(isSelected ? Color.colorpath : Color(red: 0.92, green: 0.92, blue: 0.92))
                .cornerRadius(20)
        }
        .padding(.horizontal, 5)
    }
}


struct ResultView: View {
    var designPoints: Int
    var frontendPoints: Int
    var backendPoints: Int
    var resetAction: () -> Void
    @State private var navigateToHome = false
    @State private var buttonTapped = false

    var body: some View {
        ZStack {
            Color(.black).ignoresSafeArea()
//            Text("Result:")
//                .font(.title)
//                .padding(.bottom, 20)

            if designPoints > frontendPoints && designPoints > backendPoints {
                
                
              //  Text("You are a Designer!")
                    
                    Image("image1")
                        .frame(width: 193, height: 193)
                        .padding(.bottom , 100)
                    
                    
                    VStack(spacing: 150){
                        
                  
                      
                    Spacer().frame(width: 10 , height: 300)
                        
                        Text("YOU ARE \nUI/UX DEVOLPER")
                        .font(
                        Font.custom("SF Pro", size: 26)
                        .weight(.bold)
                        )
                        .kerning(0.65566)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)

                        .frame(width: 349, alignment: .top)
                        
                        
//                        Text("Go to Dieyah Room to learn more !")
//                        .font(
//                        Font.custom("SF Pro", size: 15)
//                        .weight(.bold)
//                        )
//                        .kerning(0.65566)
//                        .multilineTextAlignment(.center)
//                        .foregroundColor(.white)
//
//                        .frame(width: 288, height: 28, alignment: .center)
//
//                        

                        
                    }

                
            } else if frontendPoints > designPoints && frontendPoints > backendPoints {
              //  Text("You are a Frontend Developer!")
               
                    Image("22")
                        .frame(width: 193, height: 193)
                        .padding(.bottom , 100)
                    
                    
                    VStack(spacing: 150){
                        
                  
                      
                    Spacer().frame(width: 10 , height: 300)
                        
                        Text("YOU ARE FRONT-END DEVLOPER ")
                        .font(
                        Font.custom("SF Pro", size: 26)
                        .weight(.bold)
                        )
                        .kerning(0.65566)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)

                        .frame(width: 349, alignment: .top)
                        
                        
//                        Text("Go to the line Room to learn more !")
//                        .font(
//                        Font.custom("SF Pro", size: 15)
//                        .weight(.bold)
//                        )
//                        .kerning(0.65566)
//                        .multilineTextAlignment(.center)
//                        .foregroundColor(.white)
//
//                        .frame(width: 288, height: 28, alignment: .center)
//                        
                        

                        
                    }
                
                
                
            } else if backendPoints > designPoints && backendPoints > frontendPoints {
              //  Text("You are a Backend Developer!")
               
                    Image("Image")
                        .frame(width: 193, height: 193)
                        .padding(.bottom , 100)
                    
                    
                    VStack(spacing: 150){
                        
                  
                      
                    Spacer().frame(width: 10 , height: 300)
                        
                        Text("YOU ARE BACK-END DEVLOPER")
                        .font(
                        Font.custom("SF Pro", size: 26)
                        .weight(.bold))
                        .kerning(0.65566)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)

                        .frame(width: 349, alignment: .top)
                        
//                        Text("Go to  Redsea Room to learn more !")
//                        .font(
//                        Font.custom("SF Pro", size: 15)
//                        .weight(.bold)
//                        )
//                        .kerning(0.65566)
//                        .multilineTextAlignment(.center)
//                        .foregroundColor(.white)
//
//                        .frame(width: 288, height: 28, alignment: .center)
//                        
//                        
//
//                        

                    }
                
                
                
                
            } else {
            //    Text("You have a diverse skillset!")
                
                
                
                
                Image("Image")
                    .frame(width: 193, height: 193)
                    .padding(.bottom , 100)
                
                
                VStack(spacing: 150){
                    
              
                  
                Spacer().frame(width: 10 , height: 300)
                    
                    Text("YOU ARE A FULLSTACK DEVLOPER")
                    .font(
                    Font.custom("SF Pro", size: 26)
                    .weight(.bold)
                    )
                    .kerning(0.65566)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.white)

                    .frame(width: 349, alignment: .top)
                    
//                    
//                    Text("Go to  Redsea Room to learn more !")
//                    .font(
//                    Font.custom("SF Pro", size: 15)
//                    .weight(.bold)
//                    )
//                    .kerning(0.65566)
//                    .multilineTextAlignment(.center)
//                    .foregroundColor(.white)
//
//                    .frame(width: 288, height: 28, alignment: .center)
                    
                    

                    
                }
            
                
            }


                
            NavigationLink (destination: ContentView(buttonTapped: buttonTapped).navigationBarBackButtonHidden(true) ){
                    HStack {
                        Image("x")
                            .font(
                                Font.custom("SF Pro", size: 26)
                                    .weight(.bold)
                            )
                            .kerning(0.65566)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)

                            .frame(width: 32, height: 43, alignment: .center)
                    }
                    .padding(.bottom, 600)
                    .padding(.trailing, 300)
                }

           
        }.ignoresSafeArea()
     //   .padding()
    }
}

#Preview {
    PathWays()
}
