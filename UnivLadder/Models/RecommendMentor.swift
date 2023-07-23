//
//  RecommendMentor.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/06/04.
//

import Foundation

//Struct를 Userdefault에 저장하기 위해 Codable 형태로 저장
struct RecommendMentor: Codable {
    let mentoId: Int
    //account
    let id: Int
    let thumbnail: String?
    let name: String
    
    let mentoringCount: Int?
    let minPrice: Int?
    let maxPrice: Int?
    let description: String?
    let reviewCount: Int?
    let totalReviewScore: Int?
    let averageReviewScore: Double?
    
    
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
