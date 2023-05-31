//
//  LoginModel.swift
//  TutumNetUI
//
//  Created by Apple on 18/05/23.
//

import Foundation

// MARK: - Login
struct LoginModel: Codable {
   
    let status: Bool
    let message, token, sendNotification: String?
    let isfirstlogin: Bool?
    let errors: Errors?

    enum CodingKeys: String, CodingKey {
        case status, message, token, isfirstlogin
        case sendNotification = "send_notification"
        case errors
    }
 
    // MARK: - Errors
    struct Errors: Codable {
        let devicetokon, email, password: [String]?
    }

}

