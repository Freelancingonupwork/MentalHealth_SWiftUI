//
//  MessageModel.swift
//  TutumNetUI
//
//  Created by Apple on 24/05/23.
//

import Foundation

// MARK: - MessageModel
class MessageModel: Codable {
    let status: Bool
    let message: String?

    init(status: Bool, message: String?) {
        self.status = status
        self.message = message
    }
}
