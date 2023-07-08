//
//  MentoSubject.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/06/25.
//

import Foundation

//Struct를 Userdefault에 저장하기 위해 Codable 형태로 저장
struct MentoSubject: Codable {
    let id: Int
    let accountId: Int
    let mentorId: Int
    let extracurricularSubjectCode: Int
}
