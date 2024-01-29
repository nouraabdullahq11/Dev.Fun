//
//  Rock.swift
//  DevFun
//

import SwiftUI
struct QuestionModel {
    let prompt: String
    let choices: [String]
    let correctIndex: Int
    let hint: String

    init(prompt: String, choices: [String], correctIndex: Int, hint: String) {
        self.prompt = prompt
        self.choices = choices
        self.correctIndex = correctIndex
        self.hint = hint
    }
}
struct Rock: View {
    @State private var currentQuestionIndex = 0
    @State private var selectedAnswerIndex: Int?
    @State private var showSubmitButton = false
    @State private var score = 0
    @State private var showScore = false
    @State private var correctAnswerText: String = ""
    @State private var showAlert = false
    
    let questions = [
        QuestionModel(
            prompt: "Gamification in software development is..",
            choices: [" Motivates users with game elements", "A programming language", "User-friendly design"],
            correctIndex: 0,
            hint: "this a hint. test"
        ),
        QuestionModel(
            prompt: "Purpose of an App Store Product Page is..",
            choices: ["Customer support for the app.", "Showcases app features for downloads", "To track user behavior within the app"],
           correctIndex: 1,
            hint: "this a hint1. test"
        ),
        QuestionModel(
            prompt: "What is an app icon?",
            choices: ["Hidden feature", "App symbol ", "Programming type."],
            correctIndex: 1,
            hint: "this a hint2. test"
        ),
        QuestionModel(
            prompt: "Usability testing in software development is ..",
            choices: ["Boosts performance", "User test", "Debugging"],
             correctIndex: 1,
            hint: "this a hint3. test"
        ),
        QuestionModel(
            prompt: "What is (C&C) analyses in business?",
            choices: ["Tak Reports", "Loyalty Strategy", "Strategic tools used to Market evaluation."],
           correctIndex: 2,
            hint: "this a hint4. test"
        ),
        QuestionModel(
            prompt: "What is URL in web development?",
            choices: ["Used to access resources", "A programming language", "A website design tool"],
          correctIndex: 0,
            hint: "this a hint4. test"
        ),
        QuestionModel(
            prompt: "What is JSON in web development?",
            choices: ["A web browser", "A web development framework", "A Data structuring from a URL"],
            correctIndex: 2,
            hint: "this a hint4. test"
        ),
        QuestionModel(
            prompt: "Purpose of async-await in programming is..",
            choices: ["simplifies arithmetic calculations","Handles Asynchronous Operations"," Manages Memory aAllocation"],
            correctIndex: 1,
            hint: "this a hint4. test"
        ), QuestionModel(
            prompt: "Closure in programming is..",
            choices: ["Allow Functions to Access Variables","Prevent Access to External Variables","Control Program Flow"],
           correctIndex: 0,
            hint: "this a hint4. test"
        )
    ]
    
    var body: some View {
        NavigationView {
            ZStack{
                VStack{
                    VStack{
                        // Spacer()
                        Text(questions[currentQuestionIndex].prompt)
                        
                        //                            .font(.system(size: 35))
                        //                            .bold()
                            .font(.title)
                            .fontWeight(.bold)
                        //.foregroundColor(.black)
                        
                        
                        
                    }
                 
//                    VStack{
                        ForEach(0..<questions[currentQuestionIndex].choices.count) { index in
                            Button(action: {
                                selectAnswer(index)
                            }) {
                                VStack(spacing: 5)
                                {
                                    Text(questions[currentQuestionIndex].choices[index])
                                        .foregroundColor(selectedAnswerIndex == index ? Color.white: Color(.black))
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                            //.foregroundColor/*(selectedAnswerIndex == index ? Color.blue :Color(red: 0.92, green: 0.92, blue: 0.92))*/
                                                .foregroundColor(selectedAnswerIndex == index ? (selectedAnswerIndex == questions[currentQuestionIndex].correctIndex ? Color.blue : Color.gray) : Color(red: 0.92, green: 0.92, blue: 0.92))
                                            
                                            
                                            // .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 4)
                                            
                                        )
                                    if selectedAnswerIndex == index && selectedAnswerIndex != questions[currentQuestionIndex].correctIndex {
                                        Text(correctAnswerText)
                                            .foregroundColor(.black)
                                            .padding(.leading)
                                    }
                                }
                            }
                            
                            //.offset(CGSize(width:5, height: 60))
//                        } /*.offset(CGSize(width:5, height: 100))*/
                    }//}
                    VStack{
                        if showSubmitButton {
                            NavigationLink(destination: RockView(), isActive: $showScore) {
                                EmptyView()
                            }
                            .hidden()
                            
                            Button(action: {
                                calculateScore()
                                showScore = true
                                
                            }) {
                                Text("Submit")
                                    .padding()
                                    .foregroundColor(.white)
                                    .background(Color.green)
                                    .cornerRadius(8)
                                
                            }
                        } else {
                            Button(action: {
                                nextQuestion()
                                showAlert = false
                            }) {
                                
                                Text("Next Question")
                                    .foregroundColor(.blue)
                                //.frame(width: 36, height: 27)
                                //.cornerRadius(8)
                                    .disabled(selectedAnswerIndex == nil)
                                
                                
                                
                            }
                            
                            
                        }
                        
                        Spacer()
                    } .padding(.top , 15)
                }
                .padding()
                .padding(.top , 100)
                //                }.navigationBarItems(leading: HStack){
                //
                //
                //
                //                }
                
                // Removed the alert and added hint display
                //                ZStack{
                //                    VStack {
                //                        if showAlert {
                //                            //                    Text("Wrong Answer ")
                //                            //                        .font(.largeTitle)
                //                            //                        .foregroundColor(.red)
                //                            Text("*Hint*: *\(questions[currentQuestionIndex].hint)*")
                //                                .foregroundColor(.black)
                //                                .fontWeight(.medium)
                //
                //                        }
                //                    }
                //                    .padding(.top, 300)
                //                    .offset(CGSize(width:5, height: 60))
                //                }
                
            }
            //.navigationBarBackButtonHidden(true)
        }
    }
    
    private func selectAnswer(_ index: Int) {
        selectedAnswerIndex = index
        
        if let selectedAnswerIndex = selectedAnswerIndex {
            if selectedAnswerIndex != questions[currentQuestionIndex].correctIndex {
                // User selected the wrong answer, set showAlert to true
                showAlert = true
            }
        }
    }
    
    private func nextQuestion() {
        if selectedAnswerIndex != nil {
            if let selectedAnswerIndex = selectedAnswerIndex {
                score += (selectedAnswerIndex == questions[currentQuestionIndex].correctIndex) ? 1 : 0
            }
            currentQuestionIndex += 1
            selectedAnswerIndex = nil
            
            if currentQuestionIndex == questions.count - 1 {
                showSubmitButton = true
            }
        }
    }
    
    private func calculateScore() {
        if let selectedAnswerIndex = selectedAnswerIndex {
            score += (selectedAnswerIndex == questions[currentQuestionIndex].correctIndex) ? 1 : 0
        }
    }
    
    private func buttonBackgroundColor(_ index: Int) -> Color {
        if let selectedAnswerIndex = selectedAnswerIndex {
            return (selectedAnswerIndex == index) ? (selectedAnswerIndex == questions[currentQuestionIndex].correctIndex ? .green : .gray) : Color(red: 0.92, green: 0.92, blue: 0.92)
        } else {
            return Color(red: 0.92, green: 0.92, blue: 0.92)
        }
    }
}

struct HintsMass {
    let prompt: String
    let choices: [String]
    let correctIndex: Int
    let hint: String
}


        

    
    struct Rock_Previews: PreviewProvider {
        static var previews: some View {
            Rock()
        }
    }


