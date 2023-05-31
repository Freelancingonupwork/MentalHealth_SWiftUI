////
////  Utils.swift
////  Flix
////
////  Created by Kaushal Parmar on 24/06/21.
////
//
import Foundation
import UIKit
import Toast_Swift
import SwiftUI
import AVFoundation
import Photos

class Utils
{
//    //MARK: - Toast
    class func showToast(strMessage : String)
    {
        if let view = UIApplication.shared.windows[0].rootViewController?.view {
            view.makeToast(strMessage)
        }
    }
    
    //MARK: - alert
    
    class func showAlert(title: String = appName , msg : String, positiveAction : @escaping (() -> Void), negativeAction : @escaping (() -> Void)) -> Alert{
        let positiveBtn : Alert.Button = .destructive(Text("Ok")){
            print("positive action")
            positiveAction()
        }
        let negativeBtn : Alert.Button = .default(Text("Cancel")){
            print("negative action")
            negativeAction()
        }
        
        return Alert(title: Text(title), message: Text(msg) ,primaryButton: positiveBtn, secondaryButton: negativeBtn)
        
    }

    class func getImageActionsSheet(cameraAction : @escaping ((Bool) -> Void), galleryAction : @escaping ((Bool) -> Void)) -> ActionSheet{
        let cameraButton : ActionSheet.Button = .default(Text("Camera")){
            print("camera")
            if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) ==  AVAuthorizationStatus.authorized {
                cameraAction(true)
            } else {
                AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted: Bool) -> Void in
                   if granted == true {
                       cameraAction(true)
                   } else {
                       cameraAction(false)
                   }
               })
            }
            
            
        }
        let galleryButton : ActionSheet.Button = .default(Text("Gallery"))
        {
            print("gallary")
            let photos = PHPhotoLibrary.authorizationStatus()
            if photos == .notDetermined {
                PHPhotoLibrary.requestAuthorization({status in
                    if status == .authorized{
                        galleryAction(true)
                    } else {
                        galleryAction(false)
                    }
                })
            }
            else if photos == .authorized{
                galleryAction(true)
            }
            else {
                galleryAction(false)
            }

            
        }
        let cancelButton : ActionSheet.Button = .destructive(Text("Cancel"))
        
        return ActionSheet(title: Text("Complete action using"),
                           message: Text("choose image from")
                           ,buttons: [cameraButton,galleryButton,cancelButton])
    }

//    //MARK: - Email validation
    class func isValidEmail( _ testStr:String ) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,9}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    class func isOnlyNumber( _ testStr:String ) -> Bool
    {
        let digitRegEx = "^[0-9]+$"
        let digitTest = NSPredicate(format:"SELF MATCHES %@", digitRegEx)
        return digitTest.evaluate(with: testStr)
    }

//
    //MARK: - Set data,get Data,remove data from User Defaults
    class func removeLocalStorageData(key : String){
        UserDefaults.standard.removeObject(forKey: key)
        UserDefaults.standard.synchronize()
    }
    class func storeDataInLocal(key: userKey, _ value: Any) {

        UserDefaults.standard.setValue(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }

    class func getDataFromLocal(key: userKey) -> AnyObject {
        return (UserDefaults.standard.object(forKey: key.rawValue) ?? "") as AnyObject
    }

}
