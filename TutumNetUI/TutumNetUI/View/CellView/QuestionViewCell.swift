//
//  QuestionCell.swift
//  TutumNetUI
//
//  Created by Apple on 19/05/23.
//

import SwiftUI

struct QuestionViewCell : View{
    
    //MARK: -  variable
    var answers : [QuestionModel.Datum.GoalQuestion.GetAnswer]? = []
    var questionData : QuestionModel.Datum{
        didSet{
            answers = questionData.goalQuestions?[0].getAnswers ?? []
        }
    }
    @Binding var arrAnswerIds : [Int]
    @Binding var arrWrongQue : [Int]
    private var questiontype : questionType
    private let btnDoneAction: () -> Void
    private var progress = 0.0
    private let hours = Array(0...24).map { String($0) }
    @State private var sleepText = strSleepHour != "" ? strSleepHour : "Hour*"


    init(questionData: QuestionModel.Datum,currentQuestion arrAnswerIds : Binding<[Int]>, arrWrongQue : Binding<[Int]>, questiontype : questionType, progress : Double = 0.0, btnDoneAction: @escaping () -> Void = {}) {
        self.questionData =  questionData
        answers = questionData.goalQuestions?[0].getAnswers ?? []
        _arrWrongQue = arrWrongQue
        _arrAnswerIds = arrAnswerIds
        self.questiontype = questiontype
        self.btnDoneAction = btnDoneAction
        self.progress = progress
    }
        
    //MARK: - view
    var body: some View{
        if questiontype == .normal {
            if questionData.goalTitle == "Sleep"{
                VStack{
                    Image("sleep").resizable().frame( height: screenSize.height/3)
                        .padding([.bottom], 20)
                            VStack{
                                HStack{
                                    Image("clock").resizable().frame(width: 30, height: 30)
                                        .padding(15)
                                    Menu(content: {
                                        ForEach(hours, id: \.self ){ item in
                                            Button(action: {
                                                strSleepHour = item
                                                sleepText = item
                                            }, label: {
                                                Text(item).setLightFont(color: .regularFontColor)
                                            })
                                        }
                                        
                                    }) {
                                        Text(sleepText).setLightFont(color: .black)
                                    }
                                    
                                    Spacer()
                                }
                            }.dropShadowAndCorner()
                }
            }
            else{
                ForEach(answers ?? []){ item in
                    let myEnum = ansColor(rawValue: item.answertype ?? answerType.correctAnswer.rawValue)
                    let color =  myEnum?.getAnsColor() ?? Color.regularFontColor
                    Button(action: {
                        btnAnsClick(answer: item)
                    }, label: {
                        VStack{
                            HStack{
                                AsyncImage(url: URL(string: item.icon ?? "")) { image in
                                    image.resizable().frame(width: 50, height: 50).padding(.all, 10).padding(.leading, 10)//.aspectRatio(contentMode: .fit)
                                } placeholder: {
                                    defaultImage.resizable().frame(width: 50, height: 50).padding(.all, 10).padding(.leading, 10)
                                }
                                Text(item.answer ?? "").setFont(color: arrAnswerIds.contains(where:  { $0 == item.id} ) ? .white : color, font: 15)
                                Spacer()
                            }
                        }
                        .background(arrAnswerIds.contains(where:  { $0 == item.id} ) ? color : .white)
                        .dropShadowAndCorner(color: arrAnswerIds.contains(where:  { $0 == item.id} ) ? color : .btnBorder)
                    })
                    .cornerRadius(10)
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        
        else if questiontype == .msg {
            VStack(spacing: 0){
                HStack{
                    Image("done").resizable().frame(width: 50, height: 50).padding(.all, 10).padding(.leading, 10)
                    Text("You are all done with your daily tracking today").setLightFont(color: .regularFontColor)
                    Spacer()
                }.dropShadowAndCorner(color: .btnBorder).padding(.bottom, 20)
                Divider().padding(.bottom, 20)

                Text("Goals achieved today")
                    .padding(.bottom,30)
                
                ZStack {
                    CircularProgressView(progress: progress)
                    
                    Circle()
                    .fill(Color.lightBlueColor.opacity(0.2))
                    .frame(width: 100, height: 100)
     
                    Text("\(progress * 100, specifier: "%.0f")%")
                        .setFont(color: .lightBlueColor, font: 18)
                        .gradientForeground()
                    
                }.frame(width: 130, height: 130)
                    .padding(.bottom, 30)
                
                Spacer()
                
                VStack {
                    Button(action: {
                        btnDoneAction()
                    }, label: {
                        Text("Done")
                            .font(MainFont.bold.with(size: 18))
                            .foregroundColor(.white)

                    }).frame(height: 50)
                }.frame(maxWidth : .infinity)
                    .gradientBackround()
                    .cornerRadius(10)
            }
            .background(.white)

        }
    }
    
    //MARK: -  button clicks
    private func btnAnsClick(answer : QuestionModel.Datum.GoalQuestion.GetAnswer){
        let currentQuestionDict = questionData.goalQuestions?[0]
        let selectedAnswer = answer
        
        if currentQuestionDict?.hasmultipleanswer == "NO"{
           handleSingleAnswer(selectedAnswer: selectedAnswer)
        }
        
        else{
            if currentQuestionDict?.disablednagativeanswer == "NO"{
                if selectedAnswer.answertype ==  answerType.wrongAnswer.rawValue{
                    handleSingleAnswer(selectedAnswer: selectedAnswer)
                    arrWrongQue.append(currentQuestionDict?.id ?? 0)
                }
                else{
                    if arrWrongQue.contains(where:  { $0 == currentQuestionDict?.id }) {
                        arrAnswerIds = []
                        arrWrongQue.removeAll(where:  { $0 == currentQuestionDict?.id })
                    }
                    handleMultipleAnswers(selectedAnswer:  selectedAnswer  )
                }
            }
            else{
                handleMultipleAnswers(selectedAnswer:  selectedAnswer  )
            }
        
        }
    }
    
    func handleMultipleAnswers(selectedAnswer : QuestionModel.Datum.GoalQuestion.GetAnswer){
        if arrAnswerIds.contains(where: { $0 == selectedAnswer.id ?? 0 }){
            arrAnswerIds.removeAll(where: { $0 == selectedAnswer.id ?? 0  })
        }
        else{
            arrAnswerIds.append(selectedAnswer.id ?? 0)
        }
    }
    
    func handleSingleAnswer(selectedAnswer : QuestionModel.Datum.GoalQuestion.GetAnswer ){
        arrAnswerIds.removeAll()
        arrAnswerIds.append(selectedAnswer.id ?? 0)
        
    }
    
    
}
//MARK: -  preview
//struct QuestionViewCell_Previews: PreviewProvider {
//    static var previews: some View {
//        QuestionViewCell( )
//    }
//}
//
struct CircularProgressView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color.lightBlueColor.opacity(0.5),
                    lineWidth: 15
                )
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.lightBlueColor,
                    style: StrokeStyle(
                        lineWidth: 15,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                // 1
                .animation(.easeOut, value: progress)

        }
    }
}
