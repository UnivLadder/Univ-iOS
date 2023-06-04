//
//  RecommendMentor.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/06/04.
//

import Foundation
import SwiftyJSON

//Struct를 Userdefault에 저장하기 위해 Codable 형태로 저장
struct RecommendMentor: Codable {
    let id: Int
    let thumbnail: String?
    let name: String
}

//[ {
//  "id" : 17,
//  "account" : {
//    "id" : 40,
//    "thumbnail" : "thumbnail",
//    "name" : "김재연"
//  },
//  "mentoringCount" : 0,
//  "minPrice" : null,
//  "maxPrice" : null
//} ]
