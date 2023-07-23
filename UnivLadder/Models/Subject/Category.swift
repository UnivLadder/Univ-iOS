//
//  Category.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/05/21.
//

import Foundation
//categry > topic
//과목 > value

struct Category {
    let categoryCode: Int
    let img: String?
    let topic: String
    let subjects: [SubjectModel]?
}

//{
//        "code": 1,
//        "topic": "외국어",
//        "value": "영어"
//},
