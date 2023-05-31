//
//  GoalSelectionModel.swift
//  TutumNetUI
//
//  Created by Apple on 19/05/23.
//

import Foundation



// MARK: - GoalSelectionModel
class GoalSelectionModel: ObservableObject,Codable {
    @Published var status: Bool = false
    @Published var message: String? = ""
    @Published var data: [Data]? = nil
    
    enum CodingKeys: String, CodingKey {
        case status
        case message
        case data
    }
    
    init() {}


   required init(from decoder: Decoder) throws {
       let container = try decoder.container(keyedBy: CodingKeys.self)
       status = try container.decode(Bool.self, forKey: .status)
       message = try container.decode(String.self, forKey: .message)
       data = try container.decode([Data].self, forKey: .data)
   }

   func encode(to encoder: Encoder) throws {
       var container = encoder.container(keyedBy: CodingKeys.self)
       try container.encode(status, forKey: .status)
       try container.encode(message, forKey: .message)
       try container.encode(data, forKey: .data)
   }
    
    // MARK: - Datum
    struct Data: Codable, Identifiable {
        let id: Int?
        let goals: String?
        let icon: String?
        let trackactive: String?
    }
}


