//
//  DummyData.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/02/06.
//

import Foundation
import Alamofire

struct DummyData {
    static var username = "test@gmail.com"
    static var password = "PASSWORD"
    
    static var accessToken = ""
    
    static let singInDummy: Parameters = [
        "username" : username,
        "password" : password
    ]
    
    static var resultDummy: Parameters = [
        "accessToken" : accessToken
    ]
}
