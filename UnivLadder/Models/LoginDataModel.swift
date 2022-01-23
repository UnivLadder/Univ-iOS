//
//  LoginDataModel.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/01/23.
//

import Foundation
import Alamofire

struct LoginDataModel {
    static var token = ""
    
    static let registeParam: Parameters = [
        "token" : token
    ]
}

// MARK: - UserData
struct UserData: Codable {
    let userID: Int
    let userNickname, token: String

    enum CodingKeys: String, CodingKey {
        case userID = "UserId"
        case userNickname = "user_nickname"
        case token
    }
}

