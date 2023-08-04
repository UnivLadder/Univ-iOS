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
    var totalReviewScore: Double?
    var averageReviewScore: Double?
    var listOfExtracurricularSubjectData: [Subject]?
    
    struct Account: Hashable, Codable{
        var id: Int
        var thumbnail: String?
        var name: String
    }
    
    struct Subject: Hashable, Codable{
        var code: Int
        var topic: String?
        var value: String
    }
}
