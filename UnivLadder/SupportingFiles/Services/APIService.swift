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
    
    // MARK: - 로그인 API
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
                        //                        UserInfo.accessToken = String(describing: token)
                        
                        // 토큰 정보 저장
                        let keyChain = KeyChain()
                        if keyChain.addItem(id: param["username"] as! String, token: token as! String){
                            print("토큰 저장 성공")
                            
                        }
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
    
    // MARK: - 회원가입 API
    // 회원가입 - 인증 이메일 보내기 API
    func postEmailAuth(param: Parameters){
        AF.request(Config.baseURL+"sign-up/verify-email", method: .post, parameters: param, encoding: JSONEncoding.default).responseString { response in
            switch response.result {
            case .success(_):
                print("success")
            case .failure(let error):
                print("Error while querying database: \(String(describing: error))")
            }
        }
    }
    
    // 회원가입 - 메일 인증번호 validate 처리 API
    // http://52.78.43.121/sign-up/verify-email
    //    {
    //      "email" : "leeyeon0527@gmail.com",
    //      "token" : "mQYicS"
    //    }
    func emailAuthNumCheckAction(param: Parameters, completion: @escaping (Bool) -> Void){
        AF.request(Config.baseURL+"sign-up/verify-confirm-email",
                   method: .post,
                   parameters: param,
                   encoding: JSONEncoding.default).responseData { response in
            if let response = response.response{
                switch response.statusCode{
                    //200인 경우만 인증 성공
                case 200:
//                    print("이메일 인증 성공")
                    completion(true)
                default:
//                    print("이메일 인증 실패")
                    completion(false)
                }
            }
//            switch response.result {
//            case .success(let data):
//                do {
//                    // response 값 추출하고 싶을 때
//                    var dicData : Dictionary<String, Any> = [String : Any]()
//                    do {
//                        // response json parsing
//                        dicData = try JSONSerialization.jsonObject(with: data, options: []) as! [String:Any]
//
//                    } catch {
//                        print(error.localizedDescription)
//                    }
//                    // Handle as previously success
//                    if let statusCode = dicData["code"]{
//                        switch statusCode as! Int{
//                        case 200..<500:
//                            print("성공")
//                        default:
//                            print("실패, statusCode : \(statusCode) ")
//                        }
//                    }
//                }
//            case .failure(let error):
//                // Handle as previously error
//                print(error)
//            }
        }
    }

    // 자체 회원가입 요청 API
    // 성공하는 경우 유저 데이터 coredata 저장
//    {
//        "accountId": 4
//    }
    func signUp(param: Parameters) {
        AF.request(Config.baseURL+"sign-up",
                   method: .post,
                   parameters: param,
                   encoding: JSONEncoding.default).responseJSON() { response in
            switch response.result {
            case .success:
                //coredata 저장
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
    // MARK: - Chatting API
    // 다이렉트 메시지를 생성
    // 다이렉트 메시지 리스트를 조회
    // 보낸거 받은거 다 로컬 디비에 저장하고, 뿌려주기
    // 최초 가입인지 아닌지 확인하는 로직 >
    // 자체 로그인시 키체인에 값이 없으면 앱 삭제 후 재로그인이므로 리스트 호출 api
    //HTTP://localhost/chats/13/messages
    
    // MARK: - FCM API
    //PUT - 서버에 FCM token 보내기
    func putFCMToken(with token: String) {
        let userData = ["fcmToken":token] as Dictionary
        let url = Config.baseURL+"accounts/43/fcm-token"
        // 최초에 파이어베이스에서 받은 토큰 저장 후 보내기
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
    
    // MARK: - UI API
    //GET - 과목 데이터 가져오기
    func getSubjects() {
        // 이전 데이터 삭제
        CoreDataManager.shared.deleteAllSubject()

        // 과목 데이터 가져오기 API
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
                        // coredata 저장
                        self.saveNewSubject(Int64(code), topic: topic, value: value)
                        print("[\(index)] code: \(code) / topic: \(topic) / value: \(value)")
                    }
                default: return
                }
                // coredata에 저장된 과목 데이터 가져오기
                self.getAllSubject()
            }
    }
    
    
    // coredata 저장
    fileprivate func saveNewSubject(_ code: Int64, topic: String, value: String) {
        CoreDataManager.shared
            .saveSubjectEntity(code: code, topic: topic, value: value, onSuccess:  { onSuccess in
                print("saved = \(onSuccess)")
            })
    }
    
    // coredata 조회
    func getAllSubject() {
        let subjects: [SubjectEntity] = CoreDataManager.shared.getSubjectEntity()
        let codes: [Int64] = subjects.map({$0.code})
        let topics: [String] = subjects.map({$0.topic!})
        let values: [String] = subjects.map({$0.value!})
        
//        let userDevices: [String]? = users.filter({$0.name == "Danny"}).first?.devices
//        let codes: [String] = users.map({$0.name!})
        print("all Codes = \(codes)")
        print("all topics = \(topics)")
        print("all values = \(values)")
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
    
    // POST1 - 자체로그인
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
