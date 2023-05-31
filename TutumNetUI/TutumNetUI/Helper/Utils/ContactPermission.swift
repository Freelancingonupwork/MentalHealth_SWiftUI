//
//  ContactPermission.swift
//  TutumNetUI
//
//  Created by Apple on 24/05/23.
//

import Foundation
import Contacts


class ContactPermission
{
    class func requestContactPermissions(completion: @escaping (Bool) -> ()) {
        _ = CNContactStore()
        let authStatus = CNContactStore.authorizationStatus(for: .contacts)
        switch authStatus {
            case .authorized:
                completion(true)
                break
            case .denied:
                completion(false)
            case .restricted, .notDetermined:
                CNContactStore().requestAccess(for: .contacts, completionHandler: { granted, error in
                    if !granted {
                       completion(false)
                    }
                    else{
                        completion(true)
                    }
                })
        @unknown default:
                break
        }
    }

}
