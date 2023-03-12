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
    
    var userAccessToken: String?
    var accountId: Int64?
    
    var emailToken: String?
    var values: [String] = [""]
    
    // MARK: - 계정 API
    // 내 계정 조회 및 coredata 저장
    func getMyAccount(){
        let url = Config.baseURL+"accounts/me"
        let accessToken = KeyChain.shared.getItem(id: "accessToken")!
        let headers: HTTPHeaders = ["Accept" : "application/json",
                                    "Content-Type" : "application/json",
                                    "Authentication" : "Bearer " + accessToken]
        AF.request(url, method: .get,  headers: headers).responseString { response in
            switch response.result{
                //200인 경우 성공
            case .success(_):
                var jsonDict : Dictionary<String, Any> = [String : Any]()
                do {
                    //한글 깨짐 문제 해결을 위한 string 화
                    let dataString = String(data: response.data!, encoding: .utf8)
                    
                    // 딕셔너리에 데이터 저장 실시
                    jsonDict = try JSONSerialization.jsonObject(with: (dataString?.data(using: .utf8))!, options: []) as! [String:Any]
                    
                    // Get the values from the JSON object
                    let accountId = jsonDict["id"] as! Int64
                    let thumbnail = jsonDict["thumbnail"] as! String
                    let email = jsonDict["email"] as! String
                    let name = jsonDict["name"] as! String
                    let gender = jsonDict["gender"] as! String
                    
                    CoreDataManager.shared
                        .saveUserEntity(accountId: accountId, email: email, gender: gender, name: name, password: nil, thumbnail: thumbnail, onSuccess: { onSuccess in
                        })
                    UIViewController.changeRootViewControllerToHome()
                } catch {
                    print(error.localizedDescription)
                }
                print("⭐️내 계정 조회 성공⭐️")
            default:
                print("👿내 계정 조회 실패👿")
            }
        }
    }
    
    // MARK: - 회원가입 API
    // 회원가입 - 회원가입 이메일 인증 요청 API
    //request
    //    {
    //      "email" : "lxxyeon@gmail.com"
    //    }
    func postEmailAuth(param: Parameters){
        AF.request(Config.baseURL+"sign-up/verify-email", method: .post, parameters: param, encoding: JSONEncoding.default).responseString { response in
            if let response = response.response{
                switch response.statusCode{
                    //200인 경우 전송 성공
                case 200:
                    print("⭐️회원가입을 위한 이메일 전송 성공⭐️")
                default:
                    print("👿회원가입을 위한 이메일 전송 실패👿")
                }
            }
        }
    }
    
    // 회원가입 - 회원가입 이메일 인증 검증 요청 API
    //request
    //    {
    //      "email" : "lxxyeon@gmail.com",
    //      "token" : "ms5Bmt"
    //    }
    func emailAuthNumCheckAction(param: Parameters, completion: @escaping (Bool) -> Void){
        AF.request(Config.baseURL+"sign-up/verify-confirm-email",
                   method: .post,
                   parameters: param,
                   encoding: JSONEncoding.default).responseData { response in
            if let response = response.response{
                switch response.statusCode{
                    //200인 경우만 성공
                case 200:
                    print("⭐️회원가입을 위한 이메일 인증 성공⭐️")
                    completion(true)
                default:
                    print("👿회원가입을 위한 이메일 인증 실패👿")
                    completion(false)
                }
            }
        }
    }
    
    // 서버 자체 회원가입 요청 API
    //request
    //    {
    //         "email" : "lxxyeon@gmail.com",
    //         "password" : "PASSWORD",
    //         "name" : "여니",
    //         "thumbnail" : "THUMBNAIL",
    //         "gender" : "WOMAN"
    //    }
    //response
    //    {
    //        "accountId": 9
    //    }
    func signUp(param: Parameters,
                completion: @escaping () -> Void){
        AF.request(Config.baseURL+"sign-up", method: .post, parameters: param, encoding: JSONEncoding.default).responseString { response in
            switch response.result{
                //200인 경우 성공
            case .success(let data):
                var jsonDict : Dictionary<String, Any> = [String : Any]()
                do {
                    // 딕셔너리에 데이터 저장 실시
                    jsonDict = try JSONSerialization.jsonObject(with: Data(data.utf8), options: []) as! [String:Any]
                    // Get the values from the JSON object
                    self.accountId = jsonDict["accountId"] as? Int64
                    UserDefaults.standard.set(jsonDict["accountId"], forKey: "accountId")
                } catch {
                    print(error.localizedDescription)
                }
                print("⭐️회원가입 성공⭐️")
                completion()
            default:
                print("👿회원가입 실패👿")
            }
        }
    }
    
    // MARK: - 로그인 API
    // 서버 자체 로그인 API
    //request
    //    {
    //         "username" : "lxxyeon@gmail.com",
    //         "password" : "PASSWORD"
    //    }
    //response
    //    {
    //        "accessToken": "~~~~"
    //    }
    func signIn(param: Parameters,
                completion: @escaping () -> Void){
        AF.request(Config.baseURL+"sign-in", method: .post, parameters: param, encoding: JSONEncoding.default).responseString { response in
            switch response.result{
                //200인 경우 성공
            case .success(let data):
                if let jsonData = data.data(using: .utf8) {
                    do {
                        if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                            // Get the values from the JSON object
                            self.userAccessToken = jsonDict["accessToken"] as? String
                        }
                    } catch {
                        // Handle error
                        print("Error: \(error.localizedDescription)")
                    }
                }
                print("⭐️로그인 성공⭐️")
                completion()
            default:
                print("👿로그인 실패👿")
            }
        }
    }
    
    //소셜 로그인
    //애플 : kakao
    //구글 : google
    //카카오 : apple
    //request
    //    {
    //      "token" : "KAKAO"
    //    }
    //response
    //    {
    //        "accessToken": "~~~~"
    //    }
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
    
    // MARK: - Chatting API
    // 다이렉트 메시지를 생성
    // 다이렉트 메시지 리스트를 조회
    // 보낸거 받은거 다 로컬 디비에 저장하고, 뿌려주기
    // 최초 가입인지 아닌지 확인하는 로직 >
    // 자체 로그인시 키체인에 값이 없으면 앱 삭제 후 재로그인이므로 리스트 호출 api
    //HTTP://localhost/chats/13/messages
    
    // MARK: - FCM API
    //PUT - 서버에 FCM token 보내기
    //request
    //    {
    //      "fcmToken" : "FCM_TOKEN"
    //    }
    func putFCMToken(param: Parameters){
        if let accessToken = KeyChain.shared.getItem(id: "accessToken"){
            let headers: HTTPHeaders = ["Accept" : "application/json",
                                        "Content-Type" : "application/json",
                                        "Authentication" : "Bearer " + accessToken]
            AF.request(Config.baseURL+"accounts/9/fcm-token", method: .put, parameters: param, encoding: JSONEncoding.default, headers: headers).responseString { response in
                if let response = response.response{
                    switch response.statusCode{
                        //200인 경우 전송 성공
                    case 200:
                        print("⭐️FCM Token 전송 성공⭐️")
                    default:
                        print("👿FCM Token 전송 실패👿")
                    }
                }
            }
        }else{
            print("👿FCM Token 전송 실패👿")
        }
    }
    
    //다이렉트 메시지 리스트 조회
    func getDirectListMessage() {
        let url = Config.baseURL+"direct-messages/list"
        let accessToken = KeyChain.shared.getItem(id: "accessToken")!
        let headers: HTTPHeaders = ["Accept" : "application/json",
                                    "Content-Type" : "application/json",
                                    "Authentication" : "Bearer " + accessToken]
        AF.request(url, method: .get,  headers: headers).responseJSON { response in
            switch response.result {
            case .success(let data):
                print("success data : \(data)")
            case .failure(let error):
                print("error : \(error)")
            }
        }
    }
    
    //다이렉트 메시지 조회
    func getDirectMessage() {
        let url = Config.baseURL+"direct-messages/7"
        let accessToken = KeyChain.shared.getItem(id: "accessToken")!
        let headers: HTTPHeaders = ["Content-Type" : "application/json",
                                    "Authentication" : "Bearer " + accessToken]
        // 과목 데이터 가져오기 API
        AF.request(url, method: .get, headers: headers)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let responseJson = JSON(value)
                    for (index, subJson) : (String, JSON) in responseJson {
                        guard let id = subJson["id"].int,
                              let senderAccountId = subJson["senderAccountId"].int,
                              
                                let message = subJson["message"].string,
                              let type = subJson["type"].string,
                              let createdDate = subJson["createdDate"].string,
                              let lastModifiedDate = subJson["lastModifiedDate"].string else {
                            continue
                        }
                        // coredata 저장
                        //                        self.saveNewSubject(Int64(code), topic: topic, value: value)
                        //                        print("[\(index)] code: \(code) / topic: \(topic) / value: \(value)")
                    }
                default: return
                }
                // coredata에 저장된 과목 데이터 가져오기
                self.getAllSubject()
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
        let accessToken = KeyChain.shared.getItem(id: "accessToken")!
        let headers: HTTPHeaders = ["Content-Type" : "application/json",
                                    "Authentication" : "Bearer " + accessToken]
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
