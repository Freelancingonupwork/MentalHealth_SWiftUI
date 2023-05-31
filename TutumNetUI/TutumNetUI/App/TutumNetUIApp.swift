//
//  TutumNetUIApp.swift
//  TutumNetUI
//
//  Created by Apple on 21/02/23.
//

import SwiftUI
import UserNotifications
import Firebase


@main
struct TutumNetUIApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
 
    var body: some Scene {
        WindowGroup {
            SplashView()
        }
    }
    
}
