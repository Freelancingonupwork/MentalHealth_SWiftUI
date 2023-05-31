//
//  GoalSelectionView.swift
//  TutumNetUI
//
//  Created by Apple on 22/02/23.
//

import SwiftUI

struct GoalSelectionView : View{
    //MARK: - variable
    private var gridItemLayout = [GridItem(.flexible()),GridItem(.flexible())]
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var arrGoalItem : [GoalSelectionModel.Data] = (arrGoals.data ?? [])
    @State private var arrSelectedGoalIds : [Int] = (arrGoals.data?.filter( { $0.trackactive == "YES" }).map( { $0.id ?? 0 }) ?? [])
    @State private var isLoading = false

    //MARK: - view
    var body: some View{
        ZStack{
            VStack{
                Rectangle().fill(Color.clear).frame(height: 50)
                ScrollView(showsIndicators: false){
                    topTextView.padding(.bottom, 30)
                    goalGridView.padding(.bottom, 20)
                    bottomTextView.padding(.bottom, 50)
                    btnContinue.padding(.bottom, 50)
                }
            }.padding(.horizontal, 20)
            if isLoading {
                Color.lightBlueColor.opacity(0.2) .edgesIgnoringSafeArea(.all)
                LottieLoaderView().frame(width: 300, height: 300)
            }
        }
        .disabled(isLoading)
        .setNavigationBar(strTitle: "Goals Selection", isBackButton: true, backButtonAction: {
            presentationMode.wrappedValue.dismiss()
        }).onAppear{
            //getGoals()
        }
    }
    
    private var topTextView : some View{
        VStack{
            Text("Which areas do you want to incude in your  self-care goals?")
                .setFont(color: .primaryColor)
                .multilineTextAlignment(.center)
        }
    }
    
    private var goalGridView : some View{
        VStack{
            let width = (screenSize.width-20)/2
            LazyVGrid(columns: gridItemLayout, spacing: 10) {
                ForEach(arrGoalItem ) { item in
                    Button(action: {
                        if !(arrSelectedGoalIds.contains(where: { $0 == item.id ?? 0 }) ){
                            arrSelectedGoalIds.append(item.id ?? 0)
                        }
                        else{
                            arrSelectedGoalIds.removeAll(where: {$0 == item.id ?? 0 })
                        }
                    }, label: {
                        GoalViewCell(goalData: item, isSelectedGoal: arrSelectedGoalIds.contains(where: { $0 == item.id ?? 0 }))
                            .padding(.vertical, 3)
                            .frame(width: width, height: width)
                    }).buttonStyle(.plain)
                    
                }
            }
        }
    }
    
    private var bottomTextView : some View{
        VStack{
            Text("We understand your goals  may change. You will be able to make changes at any time.")
                .setFont(color: .primaryColor)
                .multilineTextAlignment(.center)
        }
    }
    
    private var btnContinue : some View{
            VStack {
                Button(action: {
                    arrSelectedGoalIds.count == 0 ? Utils.showToast(strMessage: "Please select goals to track") : saveGoals()
                }, label: {
                    Text("Continue")
                        .font(MainFont.bold.with(size: 18))
                        .foregroundColor(.white)
                }).frame(height: 50)
            }.frame(maxWidth : .infinity)
                .gradientBackround()
                .cornerRadius(10)
        
    }
    
    //MARK: -  api call
    func saveGoals(){
        isLoading.toggle()
        let param : [String:Any] = ["selections" : arrSelectedGoalIds]
        APIHelper.sharedInstance.request(methodType: .post, url: Url.apiurl(apiEndPoint: .goalSelection), param: param, completion: { responseData,code in
            isLoading.toggle()
            if code == successCode {
                do{
                    let decodeJson = JSONDecoder()
                    let model =  try decodeJson.decode(MessageModel.self, from: responseData)
                    Utils.showToast(strMessage: model.message ?? "")
                    if model.status {
                        NotificationCenter.default.post(name: .refreshQuestion, object: nil, userInfo: nil)
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
//struct GoalSelectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        GoalSelectionView()
//    }
//}
