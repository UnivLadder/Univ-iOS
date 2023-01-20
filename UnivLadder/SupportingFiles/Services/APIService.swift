//
//  APIService.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/01/09.
//

import Foundation
import Alamofire
import SwiftyJSON

final class APIService {
    static let shared = APIService()
    private init() {}
    var accessToken: String?
    var emailToken: String?
    var values: [String] = [""]

    //put - FCM token
    func putFCMToken(with token: String) {
        let userData = ["fcmToken":token] as Dictionary
        let url = Config.baseURL+"accounts/43/fcm-token"
        let accessTokenTest = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJVc2VyIzQzIiwiYXVkIjoidW5pdi1sYWRkZXIiLCJyIjoiUk9MRV9VU0VSIiwidWkiOjQzLCJpc3MiOiJ1bml2LWxhZGRlciIsImV4cCI6MTY3NjM3MzE0OCwiaWF0IjoxNjczNzgxMTQ4LCJqdGkiOiJCRFZtVDZaYXRlaTR1ODhRdXAyQTBlWTdXaGdQYVFDZVA2VnFYclVYbmhQTFo5Um0wZVd1VmszbG03cndxVDJGbzRweWN4MWkwTng4NHlaVVVKTENiSjZEWE9PaG1xdTNsN2hRZk8wcHdPaHRjczFtNG9SZ21LWTRoWm5lVlNqbyJ9.U_wOhC-0VOf0Ba4432I7vWZXR0cbAhS4iCcgzSq5oiyyafwK8vgeb2YIsCrZ44-8Tc_pvTCdhHrt4aoRFaHwFQ"
        let headers: HTTPHeaders = ["Accept" : "application/json",
                                    "Content-Type" : "application/json",
                                    "Authentication" : "Bearer " + accessTokenTest]
        
        AF.request(url, method: .put, parameters: userData, headers: headers).responseData { response in
            switch response.result {
                case .success(let data):
                    print("success data : \(data)")
                case .failure(let error):
                    print("error : \(error)")
            }
        }
    }
    
    //GET - 과목 데이터
    func getSubjects() {
        AF.request(Config.baseURL+"assets/extracurricular-subjects")
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let responseJson = JSON(value)
                    for (index, subJson) : (String, JSON) in responseJson {
                        guard let code = subJson["code"].int,
                              let topic = subJson["topic"].string,
                              let value = subJson["value"].string else {
                            continue
                        }
                        // core 저장
                        self.saveNewSubject(Int64(code), topic: topic, value: value)
                        print("[\(index)] code: \(code) / topic: \(topic) / value: \(value)")
                    }
                default: return
                }
            }
    }
    
    
    // 새로운 유저 등록
    fileprivate func saveNewSubject(_ code: Int64, topic: String, value: String) {
        CoreDataManager.shared
            .saveSubjectEntity(code: code, topic: topic, value: value, onSuccess:  { onSuccess in
                print("saved = \(onSuccess)")
            })
    }
    
    //회원가입
    func signup(param: Parameters) {
        AF.request(Config.baseURL+"sign-up",
                   method: .post,
                   parameters: param,
                   encoding: JSONEncoding.default).responseJSON() { response in
            switch response.result {
            case .success:
                if let data = try! response.result.get() as? [String: Any] {
                    //                    print(Config.baseURL+"sign-up")
                    print(data)
                }
            case .failure(let error):
                print("Error: \(error)")
                return
            }
        }
    }
    
    //자체 로그인
    func signin(param: Parameters,
                completion: @escaping () -> Void){
        AF.request(Config.baseURL+"sign-in", method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON() { response in
            switch response.result {
            case .success:
                if let data = try! response.result.get() as? [String: Any] {
                    //                    print(String(describing: data["accessToken"]!))
                    //                    LoginDataModel.token = String(describing: data["accessToken"]!)
                    //토큰 로컬 저장
                    if let token = data["accessToken"]{
                        self.accessToken = String(describing: token)
                        UserInfo.accessToken = String(describing: token)
                        print("토큰 저장 성공")
                    }
                    completion()
                }
                
                break
            case .failure(let error):
                print("Error: \(error)")
                break
            }
        }
        
        
    }
    
    //소셜 로그인 - 애플, 구글
    func signinSocial(param: Parameters, domain: String) {
        AF.request(Config.baseURL+"social/sign-in/"+domain, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON() { response in
            switch response.result {
            case .success:
                if let data = try! response.result.get() as? [String: Any] {
                    print("function")
                    print(data)
                }
            case .failure(let error):
                print("Error: \(error)")
                return
            }
        }
    }
    
    func requestAPI(
        _ query: String,
        _ page: Int
    ) {
        let url = Config.baseURL + "search/" + "\(query)/\(page)"
        print(url)
        //        let url = Config.baseURL + "search/" + "\("Swift")/\(1)"
        //encoding
        if let urlEncoding = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed){
            //request
            AF.request(urlEncoding, method: .get)
            //            AF.request(urlEncoding, method: .get, parameters: parameters, encoding: URLEncoding.queryString, headers: head)
            //resposeJSON > responseString
                .responseString{dataResponse in
                    print(dataResponse.result)
                    //                    switch dataResponse.result{
                    switch dataResponse.result{
                        //jsonData >> any Type
                    case .success(let jsonData)://잘 가져왔다면
                        //                        do{
                        //                            if let json = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String : Any] {
                        //                              if let name = json["name"] as? String {
                        //                                print(name) // hyeon
                        //                              }
                        //                            }
                        //                        }
                        
                        
                        
                        do {
                            //                            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String : Any]
                            
                            let json = try JSONSerialization.data(withJSONObject: jsonData, options: .prettyPrinted)
                            
                            //                            guard let json = try! JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                            //                                             print(String(data: data, encoding: .utf8) ?? "Not string?!?")
                            //                                             return
                            //                                         }
                            
                            //                            let result = try JSONDecoder().decode(Books.self, from: json)
                            //                            let books: [Book] = result.books
                            //                            for book in books{
                            //                                print(book.title)
                            //                            }
                        }
                        catch{
                            //                            print(error.localizedDescription)
                        }
                        print("jsonData: \(jsonData)")
                    case .failure:
                        print("실패")
                    }
                }
            
            //                .responseDecodable{ (response: DataResponse<[UserData], AFError>) in
            //                    print("jsonData: \(response.result)") // decodingFailed
            //                    //                            print(response.result)
            //                    switch response.result{
            //                    case .success(let jsonData):
            //                        //                                let decoded = try decoder.decode([UserData].self, from: data!)
            //                        print("jsonData: \(jsonData)")
            //                    case .failure(let error):
            //                        print(error.localizedDescription)
            //                    }
            //
            //                }
        }
    }
    
    //POST1 - 자체로그인
    func requestAccessTokenToLogIn(with username: String, password: String) {
        let url = "https://3.38.165.81:80/sign-in"
        let headers: HTTPHeaders = ["Accept" : "application/json"]
        let parameters = ["username": username,
                          "password": password]
        AF.request(url, method: .post, parameters: parameters, headers: headers).responseJSON(){
            response in
            switch response.result {
            case .success:
                if let jsonObject = try! response.result.get() as? [String: Any] {
                    if let accessToken = jsonObject["access_token"] as? String {
                        self.getUser(accessToken: accessToken)
                        APIService.shared.accessToken = accessToken
                    }
                }
            case .failure(let error):
                print(error)
                return
            }
        }
    }
    
    func getUser(accessToken: String) {
        let url = "https://3.38.165.81:80/sign-in"
        let headers: HTTPHeaders = ["Authorization" : "token \(accessToken)"]
        AF.request(url, headers: headers).responseJSON(){
            response in
            switch response.result {
            case .success:
                var user = UserModel()
                if let jsonObject = try! response.result.get() as? [String: Any] {
                    // 토큰 가져오기
                    print(jsonObject["accessToken"] as! String)
                }
            case .failure(let error):
                print(error)
                return
            }
        }
    }
    
    func requestAccessTokenToGithub(with token: String) {
        let url = "https://github.com/login/oauth/access_token"
        let headers: HTTPHeaders = ["Accept" : "application/json"]
        let parameters = ["token": token]
        AF.request(url, method: .post, parameters: parameters, headers: headers).responseJSON(){
            response in
            switch response.result {
            case .success:
                if let jsonObject = try! response.result.get() as? [String: Any] {
                    if let accessToken = jsonObject["access_token"] as? String {
                        self.getUser(accessToken: accessToken)
                    }
                }
            case .failure(let error):
                print(error)
                return
            }
        }
    }
    //회원가입 인증 이메일 보내기
    func postEmailAuth(param: Parameters){
               AF.request(Config.baseURL+"sign-up/verify-email", method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON() { response in
                   switch response.result {
                   case .success:
                       if let data = try! response.result.get() as? [String: Any] {

//                           completion()
                       }
                       
                       break
                   case .failure(let error):
                       print("Error: \(error)")
                       break
                   }
               }    
           }

    //회원가입 인증 이메일 검증 요청
//    func emailAuthNumCheckAction(with email: String, token: String) {
//        let userData = ["email":email, "token" : token] as Dictionary
//        let url = Config.baseURL+"sign-up/verify-confirm-email"
//        let headers: HTTPHeaders = ["Content-Type" : "application/json"]
//        AF.request(url, method: .post, parameters: userData, headers: headers).responseJSON() { response in
//            print(response.result)
//            switch response.result {
//            case .success:
//                if let data = try! response.result.get() as? [String: Any] {
//                    print(data)
//                }
//                break
//            case .failure(let error):
//                print("Error: \(error)")
//                break
//            }
//        }
//    }
    
    func emailAuthNumCheckAction(param: Parameters){
               AF.request(Config.baseURL+"sign-up/verify-confirm-email", method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON() { response in
                   switch response.result {
                   case .success:
                       if let data = try! response.result.get() as? [String: Any] {

//                           completion()
                       }
                       
                       break
                   case .failure(let error):
                       print("Error: \(error)")
                       break
                   }
               }
           }
    
    
    
    
    
    //계정 이메일 수정 인증 이메일 보내기
    func putEmailModifyAuth(with email: String) {
        let userData = ["email":email] as Dictionary
//        let url = Config.baseURL+"/accounts/accountId/email"
        let url = Config.baseURL+"/accounts/3/email"
        let accessTokenTest = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJVc2VyIzMiLCJhdWQiOiJ1bml2LWxhZGRlciIsInIiOiJST0xFX1VTRVIiLCJ1aSI6MywiaXNzIjoidW5pdi1sYWRkZXIiLCJleHAiOjE2NTk0MzYxNDIsImlhdCI6MTY1Njg0NDE0MiwianRpIjoiMDNOMVg5bnduc2tWSGNQb1hDcVZHaW1peXh6dFV3RllueHZDZDRmSGZUczZ0MnRvc2lneUlnT1NiV3k0aUtQc0VKNE9nZUdQV1Uwb0VCRlg1ZlgyYk1YZ2RKQmE0UzFEUkhYdHhoMFU3R0plTmR4Q1NwMFZ3VXBNZkF0RHFqUGMifQ.zblbP_pumL9sFDia0oaMOuO9WFPahfm1jQROZ5wgs2OPS1T8dr6drmi4zjDrbqPpZGqHh4AgFvuBpGWZAvNkiw"
        
        let headers: HTTPHeaders = ["Content-Type" : "application/json",
                                    "Authentication" : "Bearer " + accessTokenTest]
        AF.request(url, method: .post, parameters: userData, headers: headers).responseJSON() { response in
            print(response.result)
            switch response.result {
            case .success:
                if let data = try! response.result.get() as? [String: Any] {
                    print(data)
                }
                break
            case .failure(let error):
                print("Error: \(error)")
                break
            }
        }
    }
}
