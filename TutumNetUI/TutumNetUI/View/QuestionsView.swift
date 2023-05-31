//
//  QuestionsView.swift
//  TutumNetUI
//
//  Created by Apple on 19/05/23.
//

import SwiftUI


struct QuestionsView : View{
    //MARK: -  variable
    @Environment(\.presentationMode) var presentationMode : Binding<PresentationMode>
    @State private var currentQuestionItem : QuestionModel.Datum?
       
    @State private var currentQuestion : Int = 0{
        didSet{
            if currentQuestion < arrQuestion.data?.count ?? 0{
                currentQuestionItem = arrQuestion.data?[currentQuestion]
                title = "Daily \(currentQuestionItem?.goalTitle ?? "") Tracking"
            }
            else{
                title = "Message"
            }
        }
    }
    @State private var title = ""
    @State private var isTrailingImg : Bool = true
    @State private var arrAnswerIds = [[Int]]()
    @State private var arrWrongQue = [Int]()
    @State private var progress = 0.0
    @State private var isLoading = false

    init(currentQuestion: Int) {
        _currentQuestion = State(initialValue: currentQuestion)
        _currentQuestionItem = State(initialValue: arrQuestion.data?[currentQuestion])
        _title = State(initialValue: "Daily \(currentQuestionItem?.goalTitle ?? "") Tracking")
        _arrAnswerIds =  State(initialValue: arrAnswerId)
        _arrWrongQue = State(initialValue: arrWrongQueID)
    }
    
    //MARK: - view
    var body: some View{
        ZStack{
            VStack{
                Rectangle().fill(Color.clear).frame(height: 50)
                ScrollView(showsIndicators: false){
                    let goalTitle =  (currentQuestionItem?.goalTitle ?? "") == "Socializing" ?  "Socialization" : (  (currentQuestionItem?.goalTitle ?? "") == "Sleep" ? "sleep" : (currentQuestionItem?.goalTitle ?? ""))
                    if currentQuestion < (arrQuestion.data?.count ?? 0){
                        Text(currentQuestionItem?.goalQuestions?[0].question ?? "", color: .lightBlueColor, forSubstring: goalTitle)
                            .setFont(color: .regularFontColor)
                            .multilineTextAlignment(.center)
                            .padding(.bottom, 20)
                        QuestionViewCell(questionData: currentQuestionItem!, currentQuestion: $arrAnswerIds[currentQuestion], arrWrongQue: $arrWrongQue, questiontype: .normal)
                    }
                    else{
                        QuestionViewCell(questionData: currentQuestionItem!, currentQuestion: $arrAnswerIds[currentQuestion-1], arrWrongQue: $arrWrongQue, questiontype: .msg, progress: progress , btnDoneAction: {
                            presentationMode.wrappedValue.dismiss()
                        })
                    }
                }
            }.padding(.all, 20)
            if isLoading{
                Color.lightBlueColor.opacity(0.2) .edgesIgnoringSafeArea(.all)
                LottieLoaderView().frame(width: 300, height: 300)

            }
        }.setNavigationBar(strTitle: title , isBackButton: true, isTrailingButton: true, trailingImg: "chevron.right", isTrailingImg: isTrailingImg, backButtonAction: {
            moveBackward()
        }, trailingButtonAction: {
            moveForward()
        })
    }
    
     //MARK: -  function
    func moveForward(){
        if currentQuestion == (arrQuestion.data?.count ?? 0){
            presentationMode.wrappedValue.dismiss()
        }
        else{
            if currentQuestionItem?.goalTitle == "Sleep"{
                if strSleepHour == "" {
                    Utils.showToast(strMessage: "please select sleep hours")
                }
                else{
                    arrAnswerIds[currentQuestion].append(currentQuestionItem?.goalQuestions?[0].getAnswers?[0].id ?? 0)
                    currentQuestion += 1
                }
            }
            else{
                if arrAnswerIds[currentQuestion].count > 0 {
                   currentQuestion += 1
               }
                else{
                    Utils.showToast(strMessage: "please select answer")
                }
            }
                
        }
          
        if currentQuestion == (arrQuestion.data?.count ?? 0){
            submitTracking()
            isTrailingImg = false
        }
        
    }
    
    func moveBackward(){
        if currentQuestion == 0{
            presentationMode.wrappedValue.dismiss()
        }
        else{
            currentQuestion -= 1
            if currentQuestion < (arrQuestion.data?.count ?? 0){
                isTrailingImg = true
            }
        }
    }
    
    //MARK: -  api call
    func submitTracking(){
        isLoading.toggle()
        var myAnswers = [[String:Any]]()
        for i in 0..<(arrQuestion.data?.count ?? 0){
            let question = arrQuestion.data?[i]
            let que = question?.goalQuestions?[0]
            var param = [String:Any]()
            param["question_id"] = que?.id
            param["answerid"] = arrAnswerIds[i]
            param["inputvalue"] =  ((que?.inputtype != "numeric") ? "null" : strSleepHour)
            myAnswers.append(param)
        }
        
        
        var param = [String:Any]()
        param = ["answers" : myAnswers]
        
        APIHelper.sharedInstance.requestJSON(methodType: .post, url: Url.apiurl(apiEndPoint: (isAnswerSubmit ?? false) ? .updateAnswers : .submitAnswers), param: param, completion: {responseData,code in
            isLoading.toggle()
            if code == successCode {
                do{
                    let decodeJson = JSONDecoder()
                    let model =  try decodeJson.decode(SubmitAnswerModel.self, from: responseData)
                    if model.status{
                        progress = Double(model.data.perecent)/100
                        NotificationCenter.default.post(name: .refreshQuestion, object: nil)
                    }
                    Utils.showToast(strMessage: model.message )
                }
                catch{
                    print(error.localizedDescription)
                    Utils.showToast(strMessage: messageKey.somethingWrong)
                }
            }
            else{
                Utils.showToast(strMessage: code)
            }
        })
    }
}

//MARK: -  preview
struct QuestionsView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionsView( currentQuestion: 0)
    }
}


