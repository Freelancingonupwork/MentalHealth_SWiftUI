//
//  ContactSelectionCell.swift
//  TutumNetUI
//
//  Created by Apple on 19/05/23.
//

import SwiftUI


struct ContactSelectionCell : View{
    //MARK: - varible
    let networktype : networkType
    var isSelectedGoal : Bool

    
    //MARK: -  view
    var body: some View{
        ZStack{
            VStack(spacing: 5){
                HStack{
                    Spacer()
                    Image( isSelectedGoal ? "goal-added" : "add-goal" ).resizable().frame(width: 25, height: 25)
                }//.background(Color.yellow)
                let myEnum = networkType(stringValue: networktype.rawValue )
                Image(myEnum?.getImageAndTitle().0 ?? "")
                    .resizable()
                    .scaledToFit()
                    .padding(.all, 0)//.background(Color.yellow)
                Text(myEnum?.getImageAndTitle().1 ?? "")
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

struct GoalViewCell_Previews: PreviewProvider {
    static var previews: some View {
        ContactSelectionCell(networktype: .friends, isSelectedGoal: false)
    }
}
