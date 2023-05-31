//
//  HistoryView.swift
//  TutumNetUI
//
//  Created by Apple on 26/05/23.
//

import SwiftUI


struct HistoryView : View{
    //MARK: -  variable
    @State private var strTitle = "Last 0 Day"
    @Environment(\.presentationMode) var presentationMode : Binding<PresentationMode>
    @State private var isLoading = false
    @State private var arrGoalsName = arrGoals.data?.map( { $0.goals })
    @State private var arrGoalsId = arrGoals.data?.map( { $0.id })
    @State private var arrSelectedGoals = [String](){
        didSet{
            strGoalText = arrSelectedGoals.count > 0 ? arrSelectedGoals.joined(separator: ",") : "Goals"
            strBottom = "Last \(strTimeText == "Time period" ? "0" : strTimeText) days for average \(strGoalText) goals"
        }
    }
    @State private var strBottom = ""
    @State private var strGoalText = "Goals"
    @State private var arrTime = ["Last 30 days","Last 15 days","Last 7 days"]
    @State private var strTimeText = "Time period"{
        didSet{
            strTitle =  "Last \(strTimeText) Day"
            strBottom = arrSelectedGoals.count > 0 ? "Last \(strTimeText == "Time period" ? "0" : strTimeText) days for average \(strGoalText) goals" : ""
        }
    }
    
    //MARK: - view
    var body: some View{
        ZStack{
            VStack{
                Rectangle().fill(Color.clear).frame(height: 50)
                ScrollView(showsIndicators: false){
                    lblTop.padding(.bottom, 30)
                    dropDownGoal.padding(.bottom, 10)
                    dropDownTime.padding(.bottom, 20)
                    lblBottom
                }
            }.padding(.all, 20)
            if isLoading{
                Color.lightBlueColor.opacity(0.2) .edgesIgnoringSafeArea(.all)
                LottieLoaderView().frame(width: 300, height: 300)
            }
        }.setNavigationBar(strTitle: strTitle, isBackButton: true, isLogo: false,backButtonAction: {
            presentationMode.wrappedValue.dismiss()
        })
        .onAppear{
           
        }
    }
    
    private var lblTop : some View {
        VStack{
            Text("Select goals and time period")
                .setFont(color: .primaryColor)
        }
    }
    
    private var lblBottom : some View {
        VStack{
            Text(strBottom)
                .setFont(color: .regularFontColor)
        }.multilineTextAlignment(.center)
    }
    
    private var dropDownGoal : some View{
        VStack{
            HStack{
                Image("goals").resizable().frame(width: 30, height: 30)
                    .padding(15)
                Menu(content: {
                    ForEach(arrGoalsName ?? [], id: \.self ){ item in
                        Button(action: {
                            strGoalText = item ?? ""
                            if arrSelectedGoals.contains(item ?? ""){
                                arrSelectedGoals.removeAll(where: { $0 == item })
                            }
                            else{
                                arrSelectedGoals.append(item ?? "")
                            }
                        }, label: {
                            Text(item ?? "").setLightFont(color: .regularFontColor)
                        })
                    }
                }) {
                    Text(strGoalText).setLightFont(color: .black)
                }
                
                Spacer()
            }
        }.dropShadowAndCorner()
    }

    private var dropDownTime : some View{
        VStack{
            HStack{
                Image("clock").resizable().frame(width: 30, height: 30)
                    .padding(15)
                Menu(content: {
                    ForEach(arrTime , id: \.self ){ item in
                        Button(action: {
                            strTimeText = item.components(separatedBy: " ")[1]
                        }, label: {
                            Text(item).setLightFont(color: .regularFontColor)
                        })
                    }
                }) {
                    Text(strTimeText == "Time period" ? strTimeText : "Last \(strTimeText) days" ).setLightFont(color: .black)
                }
                Spacer()
            }
        }.dropShadowAndCorner()
    }

    
    //MARK: -  api call
    func getTrackReport(){
        
    }

}
//MARK: -  preview
struct HistoryView_Preview : PreviewProvider{
    static var previews: some View{
        HistoryView()
    }
}
