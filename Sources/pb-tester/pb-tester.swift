import Foundation

import nyPB


@main
struct PBTester {

    static let pb = NYPB(url: URL(string: "https://08710147.xyz")!)
    static let ny = PBUser(name: "Buh", username: "buh", email: "buh@npeg.us", emailVisibility: false, password: "WhatAnAwfulPassword123484486996!", verified: false)

    static func main() async {
        let d = await pb.authUserPass(user: ny)
        switch d {
            case .success(let data): print(data)
            case .failure(let error): print("\(error): \(error.localizedDescription)")
        }
    }
}
