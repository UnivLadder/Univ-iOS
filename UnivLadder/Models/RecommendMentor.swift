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
    let id: Int
    let thumbnail: String?
    let name: String
}
