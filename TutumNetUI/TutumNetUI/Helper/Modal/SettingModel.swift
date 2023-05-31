//
//  SettingModel.swift
//  TutumNetUI
//
//  Created by Apple on 17/05/23.
//

import Foundation


struct settingModel : Identifiable {
    
    var id : Int
    var leadingImg : String
    var title : settingItems
    var trailingImg : String = ""
    var isNotification : Bool = false
    var isPositive : Bool = true

    
    static let settingItem : [settingModel] = [
        settingModel(id: 1, leadingImg: "profile-icon", title: .profile, trailingImg:  "chevron.right" ),
        settingModel(id: 2, leadingImg: "my-network", title: .myNetwork, trailingImg:  "chevron.right" ),
        settingModel(id: 3, leadingImg: "invite", title: .myInvite, trailingImg:  "chevron.right" ),
        settingModel(id: 4, leadingImg: "notification", title: .notification, isNotification: true),
        settingModel(id: 5, leadingImg: "delete", title: .deleteAccount, isPositive: false),
        settingModel(id: 6, leadingImg: "logout", title: .logout, isPositive: false),
    ]

    
}
