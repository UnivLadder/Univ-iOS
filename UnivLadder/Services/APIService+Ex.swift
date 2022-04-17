//
//  APIService+Chat.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2022/04/03.
//

import Foundation
import Alamofire

extension APIService {
    static let headers: HTTPHeaders = [
        "Authentication": "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJVc2VyIzE4IiwiYXVkIjoidW5pdi1sYWRkZXIiLCJyIjoiUk9MRV9VU0VSIiwidWkiOjE4LCJpc3MiOiJ1bml2LWxhZGRlciIsImV4cCI6MTY1MTU3Njc3OCwiaWF0IjoxNjQ4OTg0Nzc4LCJqdGkiOiJqQzRURGN3T3ZlbVBpSEdPYXJtQThiNDBQaXNMNkFLZk1xNk9QT1pSQ3VuRFM0cUluaEhTSkI2U1JndGNEV1JrUDhtWHFraVZOVlpTMW9taldjQlUzRDJyREVPaDA5dkRYM1pscVNxZkpiQUhZaWdERGlhaDZFME5jQ0xwWTlLWCJ9.slweVl_dbOsE0N5Nm0vqurKBDsLTGcAsMxOpL3w2aeIbWEm801daVJX06Vj1pok29uRYdky3rcX_YnVrIxsfgw"
    ]
    
    func post<T:Codable>(data: T, requestTask: RequestTask) {
        let parameters = ["":""]
        AF.request(Endpoint.baseURL + requestTask.rawValue,
                   method: HTTPMethod.post,
                   parameters: parameters,
                   headers: APIService.headers).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func get<T:Codable>(requestTask: RequestTask, parameters: Parameters? = nil, responseType: T.Type, completionHandler: @escaping(Result<T, AFError>) -> Void) {
        AF.request(Endpoint.baseURL + requestTask.rawValue,
                   method: HTTPMethod.get,
                   parameters: parameters,
                   headers: APIService.headers
        )
        .responseDecodable(of: responseType) { response in
            switch response.result {
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}

// MARK: - ChatRoom
struct ChatRoom: Codable {
    let id, accountID: Int
    let createdDate: String
    let lastChatMessage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case accountID = "accountId"
        case createdDate, lastChatMessage
    }
}


enum RequestTask: String {
    case chats
}

/*
 # chat

 - 채팅 생성 : chats,  (post)
 - 채팅 삭제: chats/(id),  (delete)
 - 채팅리스트 조회: chats?criteria=ALL, (Get)
 - 채팅조회: chats/(id), get

 # chat message

 - 채팅메세지 수정: /chats/(chat_id)/messages/(message_id), put
 - 채팅메세지 생성: /chats/(chat_id)/messages, post
 - 채팅메세지 삭제: /chats/(chat_id)/messages/(message_id), delete


 - 채팅 메세지들 조회: /chats/(chat_id)/messages?lastId=2147483647&displayCount=10

 # chat subscribe

 - 채팅 메시지 구독: /chats/(chat_id)/messages/subscribe

 # chat participants

 - 조회: /chats/(chatId)/participants, get
 - 삭제: /chats/(chatId)/participants/(partiId), delete
 - 생성: /chats/(chatId)/participants, post
 
 */
