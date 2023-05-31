//
//  NetworkMemberModel.swift
//  MentalHealthApp
//
//  Created by Apple on 09/11/22.
//

import Foundation

struct homeModel : Identifiable, Hashable {
    var id: Int
    let title : homeItems
    let icon : String
    let type : homeItems

    static let homeItem : [homeModel] = [
        homeModel(id: 1,title: .goalSelection, icon: "welcome-1", type: .goalSelection ),
        homeModel(id: 2,title: .network, icon: "welcome-4", type: .network ),
        homeModel(id: 3,title: .dailyTracking, icon: "daily-tracking", type: .dailyTracking ),
        homeModel(id: 4,title: .historycalResult, icon: "history", type: .historycalResult ),
        homeModel(id: 5,title: .settings, icon: "settings", type: .settings ),
    ]
}
