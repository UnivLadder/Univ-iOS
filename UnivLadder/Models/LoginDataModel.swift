//
//  LoginDataModel.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/01/23.
//

import Foundation


// MARK: - UserData
struct UserData: Codable {
    var accessToken : String

    enum CodingKeys: String, CodingKey {
        case accessToken = ""
    }
}

