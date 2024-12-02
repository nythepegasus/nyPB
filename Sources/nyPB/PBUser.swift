// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let pBUserAuthResponse = try PBUserAuthResponse(json)

import Foundation

// MARK: - PBUserAuthResponse
public struct PBUserAuthResponse: Codable, Sendable {
    public var record: PBUserRecord
    public var token: String

    public init(record: PBUserRecord, token: String) {
        self.record = record
        self.token = token
    }
}

// MARK: PBUserAuthResponse convenience initializers and mutators

public extension PBUserAuthResponse {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PBUserAuthResponse.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        record: PBUserRecord? = nil,
        token: String? = nil
    ) -> PBUserAuthResponse {
        return PBUserAuthResponse(
            record: record ?? self.record,
            token: token ?? self.token
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - PBUserRecord
public struct PBUserRecord: Codable, Sendable {
    public var avatar, collectionID, collectionName, created: String
    public var email: String
    public var emailVisibility: Bool
    public var id, name, updated, username: String
    public var verified: Bool

    public enum CodingKeys: String, CodingKey {
        case avatar
        case collectionID = "collectionId"
        case collectionName, created, email, emailVisibility, id, name, updated, username, verified
    }

    public init(avatar: String, collectionID: String, collectionName: String, created: String, email: String, emailVisibility: Bool, id: String, name: String, updated: String, username: String, verified: Bool) {
        self.avatar = avatar
        self.collectionID = collectionID
        self.collectionName = collectionName
        self.created = created
        self.email = email
        self.emailVisibility = emailVisibility
        self.id = id
        self.name = name
        self.updated = updated
        self.username = username
        self.verified = verified
    }
}

// MARK: PBUserRecord convenience initializers and mutators

public extension PBUserRecord {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(PBUserRecord.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        avatar: String? = nil,
        collectionID: String? = nil,
        collectionName: String? = nil,
        created: String? = nil,
        email: String? = nil,
        emailVisibility: Bool? = nil,
        id: String? = nil,
        name: String? = nil,
        updated: String? = nil,
        username: String? = nil,
        verified: Bool? = nil
    ) -> PBUserRecord {
        return PBUserRecord(
            avatar: avatar ?? self.avatar,
            collectionID: collectionID ?? self.collectionID,
            collectionName: collectionName ?? self.collectionName,
            created: created ?? self.created,
            email: email ?? self.email,
            emailVisibility: emailVisibility ?? self.emailVisibility,
            id: id ?? self.id,
            name: name ?? self.name,
            updated: updated ?? self.updated,
            username: username ?? self.username,
            verified: verified ?? self.verified
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
    decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
        let container = try decoder.singleValueContainer()
        let dateStr = try container.decode(String.self)

        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"
        if let date = formatter.date(from: dateStr) {
                return date
        }
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
        if let date = formatter.date(from: dateStr) {
                return date
        }
        throw DecodingError.typeMismatch(Date.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Could not decode date"))
    })
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    let formatter = DateFormatter()
    formatter.calendar = Calendar(identifier: .iso8601)
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(secondsFromGMT: 0)
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssXXXXX"
    encoder.dateEncodingStrategy = .formatted(formatter)
    return encoder
}

