//
//  Constants.swift
//  Screen Therapy
//
//  Created by Leonardo Cobaleda on 3/31/25.
//

import Foundation

enum API {
    static let baseURL = "http://10.136.251.34:8080"

    enum Apple {
        static let register = "\(baseURL)/apple/register"
        static let checkUser = "\(baseURL)/apple/checkUser"
        static let checkUsername = "\(baseURL)/apple/checkUsername"
        static let setUsername = "\(baseURL)/apple/setUsername"
    }

    enum Email {
        static let register = "\(baseURL)/email/register"
        static let login = "\(baseURL)/email/login"
    }

    enum Friends {
        static let addFriend = "\(baseURL)/friends/add"
        static let sendRequest = "\(baseURL)/friends/sendRequest"
        static let acceptRequest = "\(baseURL)/friends/acceptRequest"
        static let removeFriend = "\(baseURL)/friends/remove"
        static let list = "\(baseURL)/friends/list"
        static let getUser = "\(baseURL)/user"
    }

    enum Users {
        static func getUserById(_ userId: String) -> String {
            return "\(baseURL)/user/info/\(userId)"
        }

    }
}
