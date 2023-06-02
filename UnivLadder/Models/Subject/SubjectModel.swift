//
//  SubjectModel.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/04/17.
//

import Foundation

//Struct를 Userdefault에 저장하기 위해 Codable 형태로 저장
struct SubjectModel: Codable {
    let code: Int
    let value: String
    let topic: String
}
