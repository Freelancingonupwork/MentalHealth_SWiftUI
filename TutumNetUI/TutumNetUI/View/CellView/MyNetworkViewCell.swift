//
//  MyNetworkCell.swift
//  TutumNetUI
//
//  Created by Apple on 17/05/23.
//

import SwiftUI


struct MyNetworkViewCell : View{
    
    //MARK: -  variable
    let isInvite : Bool
    var networkItem : NetworkModel.Datum
    let btnEditAction: () -> Void
    let btnDeleteAction: () -> Void
    let btnResendAction: () -> Void


    //MARK: -  view
    var body: some View{
        ZStack{
            VStack{
                HStack{
                    VStack(){
                        let myEnum = networkType(stringValue: networkItem.type ?? "")
//                        (networkImage,networkTitle) = myEnum.getImageAndTitle()
                        Image(myEnum?.getImageAndTitle().0 ?? "")
                            .resizable()
                            .scaledToFit()
                            .padding(.all, 5)
                            .frame(width: 100)//.background(Color.yellow)
                        Text(myEnum?.getImageAndTitle().1 ?? "")
                            .multilineTextAlignment(.center)
                            .setFont(color: .primaryColor)
                            .padding(.bottom, 5)
                            //.background(Color.yellow)
                    }
                    .background(Color.lightBackground)
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                    .padding([.leading,.top, .bottom], 15)
                    
                    
                    VStack(alignment: .leading,spacing: 5){
                        Text(networkItem.name ?? "-")
                            .setFont(color: .primaryColor, font: 17)
                            
                        Text(networkItem.email ?? "-")
                            .setLightFont(color: .regularFontColor)
                        
                        Text(networkItem.phoneNumber ?? "-")
                            .setLightFont(color: .regularFontColor)
                    }.frame(maxWidth: .infinity)
                    
                    Divider()
                    
                    VStack{
                        if isInvite{
                            Button(action: btnResendAction, label: {
                                Image("resend")//.resizable()
                            })
                            
                        }
                        else{
                            Button(action: btnEditAction, label: {
                                Image("edit")//.resizable()
                            })
                            Divider()
                            Button(action: btnDeleteAction, label: {
                                Image("delete")//.resizable()
                            })
                        }
                    }.padding(.all,10)
                        .frame(width: isInvite ? 50 : 70)

                }
            }.background(Color.white)
            .dropShadowAndCorner()
        }
    }
}

////MARK: -  preview
//struct MyNetworkViewCell_Previews: PreviewProvider {
//    static var previews: some View {
//        MyNetworkViewCell(index: 0, isInvite: true)
//    }
//}
//
//
