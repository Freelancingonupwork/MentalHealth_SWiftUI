//
//  WelcomeViewCell.swift
//  TutumNetUI
//
//  Created by Apple on 22/02/23.
//

import SwiftUI


struct WelcomeViewCell : View{
    //MARK: - varible
    var welcomeData : welcomeModel
    
    //MARK: -  view
    var body: some View{
        VStack(spacing: 20){
            Image(welcomeData.imageName)
                .resizable()
                .scaledToFit()
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity, maxHeight: screenSize.height/2.5)
            
            Text(welcomeData.description)
                .multilineTextAlignment(.center)
                .setFont(color: .regularFontColor)
        }.padding(.all,20)
            //.background(Color.clear)
    }
}

struct WelcomeViewCell_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeViewCell(welcomeData: welcomeModel.menuItems[0])
    }
}
