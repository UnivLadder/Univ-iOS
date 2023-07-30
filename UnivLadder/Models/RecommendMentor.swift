//
//  RecommendMentor.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/06/04.
//

import Foundation

//Struct를 Userdefault에 저장하기 위해 Codable 형태로 저장
struct RecommendMentor: Hashable, Codable {
    
    var mentoId: Int
    var account: Account
    var mentoringCount: Int?
    var minPrice: Int?
    var maxPrice: Int?
    var description: String?
    var reviewCount: Int?
    var totalReviewScore: Int?
    var averageReviewScore: Double?
    
    struct Account: Hashable, Codable{
        var id: Int
        var thumbnail: String?
        var name: String
    }
}
//{
//  "id" : 18,
//  "account" : {
//    "id" : 41,
//    "thumbnail" : "thumbnail",
//    "name" : "김재연"
//  },
//  "mentoringCount" : 0,
//  "minPrice" : null,
//  "maxPrice" : null,
//  "description" : "",
//  "reviewCount" : 0,
//  "totalReviewScore" : 0,
//  "averageReviewScore" : 0.0
//}
