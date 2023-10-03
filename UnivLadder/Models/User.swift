//
//  UserInfo.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/07/03.
//

import Foundation

//{
//  "id" : 56,
//  "thumbnail" : "thumbnail",
//  "email" : "461616ea34e211eeaa397d8e310188ba@gmail.com",
//  "name" : "김재연",
//  "gender" : "MAN",
//  "address" : null,
//  "phoneNumber" : null,
//  "activityArea" : null,
//  "mentee" : false,
//  "mentor" : false
//}

// User memory data
final class User {
    static var accountId: Int = 0
    static var email: String = ""
    static var password: String = ""
    static var name: String = ""
    static var thumbnail: String = ""
    static var gender: String = ""
    static var mentee: Bool = true
    static var mentor: Bool = false
}
