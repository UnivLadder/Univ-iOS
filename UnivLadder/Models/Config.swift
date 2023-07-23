//
//  Config.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/01/16.
//

import Foundation
import Alamofire

struct Config {
    static let baseURL = "http://3.39.17.117:80"
    static let headers: HTTPHeaders = ["Accept" : "application/json, application/javascript, text/javascript, text/json",
                                "Content-Type" : "application/json; charset=UTF-8"]
}
