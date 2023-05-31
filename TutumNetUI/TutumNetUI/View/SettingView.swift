//
//  SettingView.swift
//  TutumNetUI
//
//  Created by Apple on 17/05/23.
//

import SwiftUI

struct SettingView : View{
    //MARK: -  variable
    @Environment(\.presentationMode) var presentationMode : Binding<PresentationMode>
    private let arrSettingItems =  settingModel.settingItem
    @State private var showLogoutAlert = false
    @State private var showDeleteAlert = false
    @State private var isLoading = false
    
    //MARK: -  view
    var body: some View{
        ZStack{
            VStack{
                Rectangle().fill(Color.clear).frame(height: 50)
                ScrollView(showsIndicators: false){
                    ForEach(arrSettingItems) { item in
                        if item.title == settingItems.profile{
                            NavigationLink(destination: EditProfileView(strFname: "", strLname: ""), label: {
                                SettingViewCell(settingViewData: item).padding(.bottom, 15)
                            })
                        }
                        else if item.title == settingItems.myNetwork{
                            NavigationLink(destination: MyNetworkView(isInvite: false), label: {
                                SettingViewCell(settingViewData: item).padding(.bottom, 15)
                            })
                        }
                        else if item.title == settingItems.myInvite{
                            NavigationLink(destination: MyNetworkView(isInvite: true), label: {
                                SettingViewCell(settingViewData: item).padding(.bottom, 15)
                            })
                        }
                        else if item.title == settingItems.deleteAccount{
                            Button(action: {
                                showDeleteAlert.toggle()
                            }) {
                                SettingViewCell(settingViewData: item).padding(.bottom, 15)
                            }.alert(isPresented: $showDeleteAlert) {
                                Utils.showAlert(title: "Delete" ,msg: "Do you want to delete account ?", positiveAction: {
                                    deleteAccount()
                                }, negativeAction: {
                                    showDeleteAlert.toggle()
                                })
                            }
                        }
                        else if item.title == settingItems.logout{
                            Button(action: {
                                showLogoutAlert.toggle()
                                
                            }) {
                                SettingViewCell(settingViewData: item).padding(.bottom, 15)
                            }.alert(isPresented: $showLogoutAlert) {
                                Utils.showAlert(title: "Logout" ,msg: "Do you want to Logout ?", positiveAction: {
                                    navigateToLogin()
                                }, negativeAction: {
                                    showLogoutAlert.toggle()
                                })
                            }
                        }
                        else{
                            SettingViewCell(settingViewData: item).padding(.bottom, 15)
                        }
                    }
                }
            }.padding(.all, 20)
            if isLoading{
                Color.lightBlueColor.opacity(0.2) .edgesIgnoringSafeArea(.all)
                LottieLoaderView().frame(width: 300, height: 300)
            }
        }.setNavigationBar(strTitle: "Settings", isBackButton: true, backButtonAction: {
            presentationMode.wrappedValue.dismiss()
        })
    }
    
    //MARK: - api call
    func deleteAccount(){
        isLoading.toggle()
        APIHelper.sharedInstance.request(methodType: .post, url: Url.apiurl(apiEndPoint: .deleteAccount), param: [:], completion: {responseData,code in
            isLoading.toggle()
            if code == successCode {
                do{
                    let decodeJson = JSONDecoder()
                    let model =  try decodeJson.decode(ProfileModel.self, from: responseData)
                    if model.status{
                        Utils.showToast(strMessage: model.message ?? "")
                        Router.showMain(view: LoginView())
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

//MARK: - preview
struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
