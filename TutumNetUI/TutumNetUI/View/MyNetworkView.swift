//
//  MyNetworkView.swift
//  TutumNetUI
//
//  Created by Apple on 17/05/23.
//

import SwiftUI

struct MyNetworkView : View{
    //MARK: -  variable
    @Environment(\.presentationMode) var presentationMode : Binding<PresentationMode>
    @State private var navigateToView = false
    @State private var navigateToEdit = false
    @State var isInvite : Bool
    @State private var arrNetworks : [NetworkModel.Datum] = []
    @State private var dictNetwork : NetworkModel.Datum = NetworkModel.Datum(id: 0, name: "", email: "", phoneNumber: "", userID: 0, type: "", isverified: "", verificationcode: "")
    private let refreshNetworkNotification = NotificationCenter.default.publisher(for: NSNotification.Name.updateNetwork )
    @State private var showDeleteAlert = false
    @State private var isLoading = false
    
    //MARK: - view
    var body: some View{
        ZStack{
            VStack{
                NavigationLink(destination: ContactSelectView(fromNetworkList: true), isActive: $navigateToView, label: {
                    EmptyView()
                })
                NavigationLink(isActive: $navigateToEdit, destination: { ContactSinUpView(arrNetwork: [], fromNetworkList: true, dictNetwrok: dictNetwork  ) }, label: { EmptyView() })
               
                Rectangle().fill(Color.clear).frame(height: 50)
                ScrollView(showsIndicators: false){
                    if arrNetworks.count == 0{
                        Text( isInvite ? "No Invitation are there" : "No Contacts are there")
                    }
                    else{
                        ForEach(arrNetworks){ item in
                            MyNetworkViewCell(isInvite: isInvite, networkItem: item, btnEditAction: {
                                editNetwork(item: item)
                            }, btnDeleteAction: {
                                showDeleteAlert.toggle()
                            }, btnResendAction: {
                                resendInvite(item: item)
                            }).padding(.bottom, 5)
                            .alert(isPresented: $showDeleteAlert) {
                                Utils.showAlert(title: "Delete" ,msg: "Do you want to delete network", positiveAction: {
                                    deleteNetwork(item: item)
                                }, negativeAction: {
                                    showDeleteAlert.toggle()
                                })
                            }
                        }
                    }
                }
            }.padding(.all, 20)
            if isLoading{
                Color.lightBlueColor.opacity(0.2) .edgesIgnoringSafeArea(.all)
                LottieLoaderView().frame(width: 300, height: 300)

            }
        }.setNavigationBar(strTitle: isInvite ? "My Invitation" : "My Network" , isBackButton: true, isTrailingButton: !isInvite ? true : false, trailingImg: !isInvite ? "plus" : "", backButtonAction: {
            presentationMode.wrappedValue.dismiss()
        }, trailingButtonAction: {
            navigateToView = true
        }).onAppear{
            getNetworkOrInvite(isInvite: isInvite)
        }.onReceive(refreshNetworkNotification, perform: { output in
            getNetworkOrInvite(isInvite: isInvite)
        })
    }
    
   
    
    //MARK: - api call
    func getNetworkOrInvite(isInvite  : Bool){
        isLoading.toggle()
        APIHelper.sharedInstance.request(methodType: .get, url: Url.apiurl(apiEndPoint: isInvite ? .getAllInvitation : .showAllNetwork), param: [:], completion: {responseData,code in
            isLoading.toggle()
            if code == successCode {
                do{
                    let decodeJson = JSONDecoder()
                    let model =  try decodeJson.decode(NetworkModel.self, from: responseData)
                    arrNetworks = model.data ?? []
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
    
    func resendInvite(item : NetworkModel.Datum){
        isLoading.toggle()
        let param : [String:Any] = ["id" : item.id ?? 0 ]
        APIHelper.sharedInstance.request(methodType: .post, url: Url.apiurl(apiEndPoint: .resendInvitation), param: param, completion: { responseData,code in
            isLoading.toggle()
            if code == successCode {
                do{
                    let decodeJson = JSONDecoder()
                    let model =  try decodeJson.decode(MessageModel.self, from: responseData)
                    if model.status{
                        getNetworkOrInvite(isInvite: isInvite)
                    }
                    Utils.showToast(strMessage: model.message ?? "")
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
    
    func editNetwork(item : NetworkModel.Datum){
        dictNetwork = item
        navigateToEdit.toggle()
    }
  
    func deleteNetwork(item : NetworkModel.Datum){
        isLoading.toggle()
        APIHelper.sharedInstance.request(methodType: .delete, url: Url.apiurl(apiEndPoint: .saveEditDeleteNetwork, extra: "\(item.id ?? 0)"), param: [:], completion: { responseData,code in
            isLoading.toggle()
            if code == successCode {
                do{
                    let decodeJson = JSONDecoder()
                    let model =  try decodeJson.decode(MessageModel.self, from: responseData)
                    if model.status{
                        getNetworkOrInvite(isInvite: isInvite)
                    }
                    Utils.showToast(strMessage: model.message ?? "")
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

////MARK: -  preview
//struct MyNetworkView_Previews: PreviewProvider {
//    static var previews: some View {
//        MyNetworkView( isInvite: false)
//    }
//}
//

