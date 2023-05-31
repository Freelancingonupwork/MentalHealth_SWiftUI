//
//  SubmitAnswer.swift
//  TutumNetUI
//
//  Created by Apple on 23/05/23.
//

import Foundation
// MARK: - SubmitAnswer
class SubmitAnswerModel: Codable {
    let status: Bool
    let data: DataClass
    let message: String

    init(status: Bool, data: DataClass, message: String) {
        self.status = status
        self.data = data
        self.message = message
    }
    
    // MARK: - DataClass
    class DataClass: Codable {
        let perecent: Int
        init(perecent: Int) {
            self.perecent = perecent
        }
    }

}

