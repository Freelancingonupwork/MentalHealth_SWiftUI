//
//  File.swift
//  TutumNetUI
//
//  Created by Apple on 06/03/23.
//

import SwiftUI
import Contacts


struct HomeView : View{
    //MARK: -  variable
    private let arrHomeItems =  homeModel.homeItem
    private let refreshQuestionNotification = NotificationCenter.default.publisher(for: NSNotification.Name.refreshQuestion )
    @State private var moveToNext = false
    @State private var isLoading = false

    //MARK: - view
    var body: some View{
        ZStack{
            VStack{
                Rectangle().fill(Color.clear).frame(height: 50)
                ScrollView(showsIndicators: false){
                    ForEach(arrHomeItems ) { item in
                        if item.title == .goalSelection{
                            NavigationLink(destination: GoalSelectionView(), label: {
                                HomeViewCell(homeViewData: item).padding(.all,5)
                            })
                        }
                        else if item.title == .dailyTracking{
                            if moveToNext{
                                NavigationLink(destination: QuestionsView(currentQuestion: 0), label: {
                                    HomeViewCell(homeViewData: item).padding(.all,5)
                                })
                            }
                            else{
                                Button(action: {
                                    Utils.showToast(strMessage: "please select the goal to track")
                                }, label: {
                                    HomeViewCell(homeViewData: item).padding(.all,5)
                                })
                            }
                        }
                        else if item.title == .network{
                            NavigationLink(destination: ContactSelectView(fromNetworkList : false), label: {
                                HomeViewCell(homeViewData: item).padding(.all,5)
                            })
                        }
                        else if item.title == .historycalResult{
                            NavigationLink(destination: HistoryView() , label: {
                                HomeViewCell(homeViewData: item).padding(.all,5)
                            })
                        }
                        else if item.title == .settings{
                            NavigationLink(destination: SettingView(), label: {
                                HomeViewCell(homeViewData: item).padding(.all,5)
                            })
                        }
                        else{
                            HomeViewCell(homeViewData: item).padding(.all,5)
                        }

                    }
                }
            }.padding(.all, 20)
            if isLoading{
                Color.lightBlueColor.opacity(0.2) .edgesIgnoringSafeArea(.all)
                LottieLoaderView().frame(width: 300, height: 300)
            }
        }.setNavigationBar(strTitle: "", isBackButton: false, isLogo: true)
        .onReceive(refreshQuestionNotification, perform: { output in
            getQuestion()
            getGoals()
        })
        .onAppear{
            if arrQuestion.data?.count == 0{
                getQuestion()
                getGoals()
            }
            else{
                moveToNext = true
            }
        }
        
    }

    //MARK: -  api call
    func getQuestion(){
        isLoading.toggle()
        APIHelper.sharedInstance.request(methodType: .get, url: Url.apiurl(apiEndPoint: .getQuestions), param: [:], completion: {responseData,code in
            isLoading.toggle()
            if code == successCode {
                do{
                    let decodeJson = JSONDecoder()
                    let model =  try decodeJson.decode(QuestionModel.self, from: responseData)
                    arrQuestion = model
                    moveToNext = arrQuestion.data?.count ?? 0 > 0 ? true : false
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
    
    func getGoals(){
        isLoading.toggle()
        APIHelper.sharedInstance.request(methodType: .get, url: Url.apiurl(apiEndPoint: .getAllGoal), param: [:], completion: {responseData,code in
            isLoading.toggle()
            if code == successCode {
                do{
                    let decodeJson = JSONDecoder()
                    let model =  try decodeJson.decode(GoalSelectionModel.self, from: responseData)
                        if model.status{
                            arrGoals = model
                        }
                        else{
                            Utils.showToast(strMessage: model.message ?? "")
                        }
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
struct HomeView_Preview : PreviewProvider{
    static var previews: some View{
        HomeView()
    }
}
