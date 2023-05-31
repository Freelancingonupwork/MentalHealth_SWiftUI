//
//  NetworkModel.swift
//  TutumNetUI
//
//  Created by Apple on 22/05/23.
//

import Foundation

class NetworkModel: Codable {
    let status: Bool
    let message: String?
    let data: [Datum]?

    init(status: Bool, message: String?, data: [Datum]?) {
        self.status = status
        self.message = message
        self.data = data
    }
    
    // MARK: - Datum
    class Datum: Codable, Identifiable {
        let id: Int?
        let name, email, phoneNumber: String?
        let userID: Int?
        let type, isverified, verificationcode: String?
       // let createdAt, updatedAt: JSONNull?

        enum CodingKeys: String, CodingKey {
            case id, name, email
            case phoneNumber = "phone_number"
            case userID = "user_id"
            case type, isverified, verificationcode
            //case createdAt = "created_at"
           // case updatedAt = "updated_at"
        }

        init(id: Int?, name: String?, email: String?, phoneNumber: String?, userID: Int?, type: String?, isverified: String?, verificationcode: String?) {
            self.id = id
            self.name = name
            self.email = email
            self.phoneNumber = phoneNumber
            self.userID = userID
            self.type = type
            self.isverified = isverified
            self.verificationcode = verificationcode
//            self.createdAt = createdAt
//            self.updatedAt = updatedAt
        }

    }
}

// MARK: NetworkModel convenience initializers and mutators

extension NetworkModel {
    convenience init(data: Data) throws {
        let me = try newJSONDecoder().decode(NetworkModel.self, from: data)
        self.init(status: me.status, message: me.message, data: me.data)
    }

    convenience init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    convenience init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        status: Bool,
        message: String?? = nil,
        data: [Datum]?? = nil
    ) -> NetworkModel {
        return NetworkModel(
            status: status ,
            message: message ?? self.message,
            data: data ?? self.data
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

