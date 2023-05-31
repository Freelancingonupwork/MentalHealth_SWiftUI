//
//  ProfileModel.swift
//  TutumNetUI
//
//  Created by Apple on 18/05/23.
//

import Foundation

struct ProfileModel: Codable {
    let status: Bool
    let message: String?
    let data: DataClass?
    
    // MARK: - DataClass
    struct DataClass: Codable {
        let id: Int?
        let username: String?
        let firstName, lastName, email, phoneNumber: String?
        //let emailVerifiedAt: JSONNull?
        let userprofileimage: String?
        let devicetokon, userType: String?
        //let contactNumber: JSONNull?
        let dob: String?
        let socialloginkey: JSONNull?
        let gender, loginwith, status, sendNotification: String?
        let createdAt, updatedAt, fullName: String?

        enum CodingKeys: String, CodingKey {
            case id, username
            case firstName = "first_name"
            case lastName = "last_name"
            case email
            case phoneNumber = "phone_number"
            //case emailVerifiedAt = "email_verified_at"
            case userprofileimage, devicetokon
            case userType = "user_type"
            //case contactNumber = "contact_number"
            case dob, socialloginkey, gender, loginwith, status
            case sendNotification = "send_notification"
            case createdAt = "created_at"
            case updatedAt = "updated_at"
            case fullName = "full_name"
        }
    }
}



// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
