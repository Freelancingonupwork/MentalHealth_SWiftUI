//
//  HomeViewCell.swift
//  TutumNetUI
//
//  Created by Apple on 06/03/23.
//

import SwiftUI

struct HomeViewCell : View{
    //MARK: -  variable
    var homeViewData : homeModel
    
    
    //MARK: -  boady
    var body: some View{
        ZStack{
            VStack{
                HStack{
                    Image(homeViewData.icon).resizable().frame(width: 50, height: 50).padding(.all, 10).padding(.leading, 10)
                    Text(homeViewData.title.rawValue).setFont(color: .primaryColor, font: 17)
                    Spacer()
                }
            }.background(Color.white)
            .dropShadowAndCorner()
        }
    }
}

struct HomeViewCell_Previews: PreviewProvider{
    static var previews: some View{
        HomeViewCell(homeViewData: homeModel.homeItem[0])
    }
}
