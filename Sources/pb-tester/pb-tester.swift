import Foundation

import ArgumentParser
import Yams

import nyPB


@main
struct PBTester: AsyncParsableCommand {

    @Argument(help: "Instance URL")
    var url: String

    @Argument(help: "Your username")
    var username: String

    @Argument(help: "Your password")
    var password: String

    mutating func run() async {
        let pb = NYPB(url: URL(string: url)!)
        let userAuth = PBUser.PBUserPassAuth(identity: username, password: password)
        let authData = await pb.authUserPass(user: userAuth)
        switch authData {
            case .success(let data): print(data)
            case .failure(let error): print("\(error): \(error.localizedDescription)")
        }
    }
}
