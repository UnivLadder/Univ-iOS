//
//  APIService+Chat.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2022/04/03.
//

import Foundation
import Alamofire

struct ChatRoomList: Codable {
    let id, accountID: Int
    let createdDate: String
    let lastChatMessage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case accountID = "accountId"
        case createdDate, lastChatMessage
    }
}


final class AFNetworkService {
    static let shared = AFNetworkService()
    private init() {}
    
    static let headers: HTTPHeaders = [
        "Authentication": "Bearer "
    ]
    
    enum RequestType: String {
        case chats
    }
    
    func post<T:Codable>(data: T, requestType: RequestType) {
        let parameters = ["":""]
        AF.request(Endpoint.baseURL + requestType.rawValue,
                   method: HTTPMethod.post,
                   parameters: parameters,
                   headers: AFNetworkService.headers).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func get(requestType: RequestType, parameters: Parameters?) {
        AF.request(Endpoint.baseURL + requestType.rawValue,
                   method: HTTPMethod.get,
                   parameters: parameters,
                   headers: AFNetworkService.headers
        )
        .validate(statusCode: 200..<500)
        .validate(contentType: ["application/json"])
        .responseDecodable(of: [ChatRoomList].self) { response in
            print("요청", response.request)
            switch response.result {
            case .success(let data):
                print("성공!", data)
            case .failure(let error):
                print("실패", error)
            }
        }
    }
}
