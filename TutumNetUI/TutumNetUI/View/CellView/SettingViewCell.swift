//
//  SettingCell.swift
//  TutumNetUI
//
//  Created by Apple on 17/05/23.
//

import SwiftUI

struct SettingViewCell : View{
    
    //MARK: -  variable
    var settingViewData : settingModel
    @State private var isSwitchOn : Bool = Utils.getDataFromLocal(key: .isNotificationOn) as? Bool ?? false
    @State private var showNotificationAlert = false
    
    //MARK: -  view
    var body: some View{
        ZStack{
            VStack{
                HStack{
                    Image(settingViewData.leadingImg).resizable().frame(width: 30, height: 30).padding(.all, 10).padding(.leading, 10)
                    Text(settingViewData.title.rawValue).setFont(color: settingViewData.isPositive ? .primaryColor : .redColor, font: 15)
                    Spacer()
                    Image(systemName: settingViewData.trailingImg).padding(.all, 10).padding(.trailing, 10).foregroundColor(.regularFontColor)
                    if settingViewData.isNotification {
                        Toggle("", isOn: $isSwitchOn ).padding(.trailing,10)
                            .toggleStyle(SwitchToggleStyle(tint: Color.lightBlueColor))
                            .onChange(of: isSwitchOn) { newValue in
                                isSwitchOn = newValue
                                showNotificationAlert.toggle()
                            }
                    }
                }.alert(isPresented: $showNotificationAlert) {
                    Utils.showAlert(title: "Notification" ,msg: "Do you want to turn \(isSwitchOn) the Notification", positiveAction: {
                        updateNotificationStatus(isOn: isSwitchOn)
                    }, negativeAction: {
                        showNotificationAlert.toggle()
                        isSwitchOn.toggle()
                    })
                }
            }.background(Color.white)
                .dropShadowAndCorner()
        }
    }
    
    //MARK: -  api call
    func updateNotificationStatus(isOn : Bool){
        let param : [String:Any] = ["send_notification": isOn ? "YES" : "NO" ]
        APIHelper.sharedInstance.request(methodType: .post, url: Url.apiurl(apiEndPoint: .notificationStatus), param: param, completion: {responseData,code in
            if code == successCode {
                do{
                    let decodeJson = JSONDecoder()
                    let model =  try decodeJson.decode(ProfileModel.self, from: responseData)
                    if model.status{
                        Utils.showToast(strMessage: model.message ?? "")
                        Utils.storeDataInLocal(key: .isNotificationOn, isOn)
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
struct SettingViewCell_Previews: PreviewProvider {
    static var previews: some View {
        SettingViewCell( settingViewData: settingModel.settingItem[0])
    }
}

