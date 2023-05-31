//
//  File.swift
//  TutumNetUI
//
//  Created by Apple on 06/03/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct GoalViewCell : View{
    //MARK: - varible
    var goalData :  GoalSelectionModel.Data
    var isSelectedGoal : Bool
    
    //MARK: -  view
    var body: some View{
        ZStack{
            VStack(spacing: 5){
                HStack{
                    Spacer()
                    Image( isSelectedGoal ? "goal-added" : "add-goal" ).resizable().frame(width: 25, height: 25)
                }
                AsyncImage(url: URL(string: goalData.icon ?? "")) { image in
                    image.resizable().aspectRatio(contentMode: .fit)
                } placeholder: {
                    defaultImage.resizable().aspectRatio(contentMode: .fit)
                }
               .padding(.all, 0)
                
                Text(goalData.goals ?? "")
                    .multilineTextAlignment(.center)
                    .setFont(color: .primaryColor)
                    .padding(.bottom, 10)
                    //.background(Color.yellow)
            }.padding(.all,10)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 20).stroke( LinearGradient(
                    colors: [Color.init(hex: "#3264ED"), Color.init(hex: "#00B9FB")],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing), lineWidth: 1)
            )
        }.padding(.horizontal, 10)
    }
}

//struct GoalViewCell_Previews: PreviewProvider {
//    static var previews: some View {
//        GoalViewCell(goalData: goalSelectionItem.init(title: "", highlightText: "", subtitle: "", imageName: "", description: "", goalItem: [], goalType: ""))
//    }
//}
