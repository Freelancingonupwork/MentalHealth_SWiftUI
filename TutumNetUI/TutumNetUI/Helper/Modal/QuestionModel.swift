//
//  QuestionModel.swift
//  TutumNetUI
//
//  Created by Apple on 19/05/23.
//

import Foundation

class QuestionModel : ObservableObject, Codable   {
    @Published var status: Bool = false
    @Published var message: String? = ""
    @Published var data: [Datum]? = []
    
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
           data = try container.decode([Datum].self, forKey: .data)
       }

       func encode(to encoder: Encoder) throws {
           var container = encoder.container(keyedBy: CodingKeys.self)
           try container.encode(status, forKey: .status)
           try container.encode(message, forKey: .message)
           try container.encode(data, forKey: .data)
       }

    // MARK: - Datum
    struct Datum: Codable {
        let id, userID, goalID: Int?
        let trackactive, createdAt, updatedAt: String?
        let goalQuestions: [GoalQuestion]?
        let goalTitle: String?
        let answerselected: Bool?

        enum CodingKeys: String, CodingKey {
            case id
            case userID = "user_id"
            case goalID = "goal_id"
            case trackactive
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case goalQuestions = "goal_questions"
            case goalTitle = "goal_title"
            case answerselected
        }
        
        // MARK: - GoalQuestion
        struct GoalQuestion: Codable, Identifiable {
            let id, goalID: Int?
                let question, inputtype, hasmultipleanswer, disablednagativeanswer: String?
                let createdAt, updatedAt: String?
                let getAnswers: [GetAnswer]?
                let selectedanswerid, trackid: [Int]?
                let inputvalue: [String]?

            enum CodingKeys: String, CodingKey {
                    case id
                    case goalID = "goal_id"
                    case question, inputtype, hasmultipleanswer, disablednagativeanswer
                    case createdAt = "created_at"
                    case updatedAt = "updated_at"
                    case getAnswers = "get_answers"
                    case selectedanswerid, trackid, inputvalue
                }
            
            enum AtedAt: String, Codable {
                case the20230316T134646000000Z = "2023-03-16T13:46:46.000000Z"
            }

            // MARK: - GetAnswer
            struct GetAnswer: Codable, Identifiable {
                let id, questionID: Int?
                let answer: String?
                let icon: String?
                let answertype: String?
                let minimumvalue, maximumvalue: Int?
                let weightage: JSONNull?
                let createdAt, updatedAt: AtedAt?

                enum CodingKeys: String, CodingKey {
                    case id
                    case questionID = "question_id"
                    case answer, icon, answertype, minimumvalue, maximumvalue, weightage
                    case createdAt = "created_at"
                    case updatedAt = "updated_at"
                }
            }
        }
    }
}
