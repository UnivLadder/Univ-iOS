//
//  AccountData.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/08/20.
//

import Foundation

struct AccountData: Hashable, Codable {
    var accountId: Int
    var email: String
    var password: String?
    var name: String
    var thumbnail: String?
    var gender: String?
    var mentee: Bool?
    var mentor: Bool?
}
