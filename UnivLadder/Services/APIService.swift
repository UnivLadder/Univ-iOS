//
//  APIService.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/01/09.
//

import Foundation
import Alamofire



class APIService {
//    static let sharedAPI = APICollection()
    let url = "http://3.38.165.81:80/"
    let param : Parameters = [
        "token" : "토큰값"
    ]

    func registeredCheck(parameters: Parameters ,completion: @escaping (_ result: String) -> (Void)){

        AF.request(url,
                   method: .post,
                   parameters: param)
//            .responseDecodable(completionHandler:     { (response: DataResponse<ResultUser>, AFError>) in
//                completion(response.result)
//    })
        
    }
    
    
//    class APIClient {
//        static func login(email: String, password: String, completion:@escaping (Result<User, AFError>)->Void) {
//            AF.request(APIRouter.login(email: email, password: password))
//                     .responseDecodable { (response: DataResponse<User, AFError>) in
//                        completion(response.result)
//            }
//        }
//    }

}

