//
//  ChattingRoom.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/06/28.
//

import Foundation

struct ChattingRoom: Codable {
    let id: Int
    let senderAccountId: Int
    let receiver: Receiver
    let message: String
    let type: String
    let createdDate: String
    let lastModifiedDate: String
    
    struct Receiver: Codable{
        let id: Int
        let name: String
    }
}
//[ {
//  "id" : 8,
//  "senderAccountId" : 11,
//  "receiver" : {
//    "id" : 12,
//    "name" : "김재연"
//  },
//  "message" : "FK4mYNEPVNIFFGBy8xp59hmYgMHd1OHmi94tIxFavtdjiIrmnf",
//  "type" : "TEXT",
//  "createdDate" : "2023-06-26T11:22:54.465",
//  "lastModifiedDate" : "2023-06-26T11:22:54.465"
//}
