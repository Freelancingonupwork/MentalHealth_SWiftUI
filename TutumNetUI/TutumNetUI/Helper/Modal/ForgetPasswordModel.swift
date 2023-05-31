//
//  File.swift
//  TutumNetUI
//
//  Created by Apple on 18/05/23.
//

import Foundation

struct ForgetPasswordModel: Codable {
    let status: Bool
    let message: String?
    let errors: Errors?
    
    // MARK: - Errors
    struct Errors: Codable {
        let email: [String]?
    }

}

