
#if !os(Linux)
import Foundation
#else
import FoundationEssentials
import FoundationNetworking
#endif

extension Encodable {
    var json: Data { try! JSONEncoder().encode(self) }
}

extension URL {
    func appending(_ components: [String]) -> URL { components.reduce(self) { $0.appending($1, isDirectory: true) } }
    func appending(_ component: String, isDirectory: Bool = true) -> URL {
        if #available(macOS 13, iOS 16.0, tvOS 13.0, watchOS 8.0, *) {
            appending(component: component, directoryHint: isDirectory ? .isDirectory : .notDirectory)
        } else { appendingPathComponent(component, isDirectory: isDirectory) }
    }
}

public struct PBUser: Codable {
    public let name: String
    public let username: String
    public let email: String
    public let emailVisibility: Bool
    public let password: String
    public let verified: Bool

    enum CodingKeys: String, CodingKey {
        case name
        case username
        case email
        case emailVisibility
        case password
        case verified
    }

    public struct PBUserSignUp: Codable {
        public let name: String
        public let username: String
        public let email: String
        public let emailVisibility: Bool
        public let password: String
        public let passwordConfirm: String
        public let verified: Bool
    }

    public struct PBUserPassAuth: Codable {
        public let identity: String
        public let password: String

        public init(identity: String, password: String) {
            self.identity = identity
            self.password = password
        }
    }

    public init(name: String, username: String, email: String, emailVisibility: Bool, password: String, verified: Bool) {
        self.name = name
        self.username = username 
        self.email = email 
        self.emailVisibility = emailVisibility 
        self.password = password 
        self.verified = verified 
    }

    var signUp: PBUserSignUp { .init(name: name, username: username, email: email, emailVisibility: emailVisibility, password: password, passwordConfirm: password, verified: verified) }
    var passAuth: PBUserPassAuth { .init(identity: username, password: password) }
}

public class NYPB {
    public let url: URL

    public init(url: URL) {
        self.url = url
    }

    public var collections: URL { url.appending(["api", "collections"]) }
    public var users: URL { collections.appending("users") }

    public func authUserPass(user: PBUser) async -> Result<PBUserAuthResponse, Error> { await authUserPass(user: user.passAuth) }
    public func authUserPass(user: PBUser.PBUserPassAuth) async -> Result<PBUserAuthResponse, Error> {
        let url = users.appending("auth-with-password")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = user.json
        do { return .success(try PBUserAuthResponse(data: try await URLSession.shared.data(for: request).0))
        } catch { return .failure(error) }
    }

    public func newUser(user: PBUser) async -> Result<Data, Error> {
        let url = users.appending("records")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = user.signUp.json
        do {
            return .success((try await URLSession.shared.data(for: request).0))
        } catch {
            return .failure(error)
        }
    }
}
