//
//  ContactSelectionView.swift
//  TutumNetUI
//
//  Created by Apple on 06/03/23.
//

import SwiftUI


struct ContactSelectView : View{
    //MARK: - variable
    var gridItemLayout = [GridItem(.flexible()),GridItem(.flexible())]
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var arrNetworkItem : [networkType] = [
        .friends,
        .parentsCartaker,
        .doctorTherapists
    ]
    @State var arrSelectedNetwork : [networkType] = []
    @State var navigateToView = false
    var fromNetworkList : Bool
    
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
        }
        .onAppear{
        }.setNavigationBar(strTitle: "Contact Selection", isBackButton: true, backButtonAction: {
            presentationMode.wrappedValue.dismiss()
        })
        NavigationLink(isActive: $navigateToView, destination: { ContactSinUpView(arrNetwork: arrSelectedNetwork, fromNetworkList: fromNetworkList, dictNetwrok: NetworkModel.Datum(id: 0, name: "", email: "", phoneNumber: "", userID: 0, type: "", isverified: "", verificationcode: "")) }, label: { EmptyView() })
    }
    
    private var topTextView : some View{
        VStack{
            Text("Your support network is here to help you  in case you are missing your daily self-care goals at an alarming rate. You will need to provide the details of at least one friend, parent/caretaker or doctor/therapist who will be notified in order to support you. The people you select will be notified via email and will need to click through to verify they want to participate. Select the people you want in your support network. You will need to enter their details in the next screen.")
                .setFont(color: .regularFontColor)
                .multilineTextAlignment(.center)
        }
    }
    
    private var goalGridView : some View{
        VStack{
            let width = (screenSize.width-40)/2
            LazyVGrid(columns: gridItemLayout, spacing: 20) {
                ForEach(arrNetworkItem, id: \.self) { item in
                    Button(action: {
                        
                        if arrSelectedNetwork.contains(item){
                            arrSelectedNetwork.removeAll(where: { $0 == item })
                        }
                        else{
                            arrSelectedNetwork.append(item)
                        }
                        
                    }, label: {
                        ContactSelectionCell(networktype: item, isSelectedGoal: arrSelectedNetwork.contains(item))
                            .padding(.vertical, 5)
                            .frame(width: width, height: width)
                    }).buttonStyle(PlainButtonStyle())
                    
                }
            }
        }
    }
    
    private var bottomTextView : some View{
        VStack{
            Text("We understand your support network may change. You will be able to make changes at any time.")
                .setFont(color: .regularFontColor)
                .multilineTextAlignment(.center)
        }
    }
    
    private var btnContinue : some View{
        
        Button(action: {
            arrSelectedNetwork.count > 0 ? navigateToView = true : Utils.showToast(strMessage: "please select network")
        }, label: {
            VStack {
                    Text("Continue")
                        .font(MainFont.bold.with(size: 18))
                        .foregroundColor(.white)
                        .frame(height: 50)
            }.frame(maxWidth : .infinity)
                .gradientBackround()
                .cornerRadius(10)
        })
        
        
    }
    
}
//MARK: -  preview

struct ContactSelectView_Previews: PreviewProvider {
    static var previews: some View {
        ContactSelectView(fromNetworkList: false)
    }
}

