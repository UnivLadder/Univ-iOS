//
//  APIService.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/01/09.
//

import Foundation
import Alamofire

final class APIService {
    
    static let shared = APIService()
    private init() {}
    
    var categories = [Category]()

    var accountId: Int?
    
    var emailToken: String?
    var values: [String] = [""]
    
    let accessToken = UserDefaults.standard.string(forKey: "accessToken")
    
    var headers: HTTPHeaders = Config.headers
    
    // MARK: - 비밀번호 재설정 API
    //    [x] 비밀번호 분실 요청
    func reportLostPassword(param: Parameters, completion: @escaping (Bool) -> Void){
        AF.request(Config.baseURL+"/accounts/report-lost-password",
                   method: .post,
                   parameters: param,
                   encoding: JSONEncoding.default,
                   headers: headers).responseString { response in
            switch response.result{
            case .success(_):
                print("⭐️메일로 토큰 전송 성공⭐️")
                
            default:
                print("👿메일로 토큰 전송 실패👿")
                completion(false)
            }
        }
    }
    //    [x] 비밀번호 초기화 검증
    func resetPassword(param: Parameters, completion: @escaping (Bool) -> Void){
        AF.request(Config.baseURL+"/accounts/reset-password/verify",
                   method: .post,
                   parameters: param,
                   encoding: JSONEncoding.default,
                   headers: headers).responseString { response in
            switch response.result{
            case .success(_):
                print("⭐️토큰 전송 성공⭐️")
                
            default:
                print("👿토큰 전송 실패👿")
                completion(false)
            }
        }
    }
    //    [x] 비밀번호 초기화
    func resetPasswordConfirm(param: Parameters, completion: @escaping (Bool) -> Void){
        AF.request(Config.baseURL+"/accounts/reset-password/confirm",
                   method: .post,
                   parameters: param,
                   encoding: JSONEncoding.default,
                   headers: headers).responseString { response in
            switch response.result{
            case .success(_):
                print("⭐️토큰 전송 성공⭐️")
                
            default:
                print("👿토큰 전송 실패👿")
                completion(false)
            }
        }
    }
    
    
    // MARK: - 멘토 API
    // 멘토 등록
    //    {
    //      "minPrice" : 100000,
    //      "maxPrice" : 200000,
    //      "description" : "멘토 수업 상세 설명",
    //      "extracurricularSubjectCodes" : [ ]
    //    }
    func registerMento(param: Parameters, completion: @escaping (Bool) -> Void){
        
        guard let mentoAccessToken = accessToken else {
            print("👿멘토 토큰 조회 실패👿")
            return
        }
            
        let headers: HTTPHeaders = ["Accept" : "application/json",
                                    "Content-Type" : "application/json",
                                    "Authentication" : "Bearer " + mentoAccessToken]
        AF.request(Config.baseURL+"/mentors",
                   method: .post,
                   parameters: param,
                   encoding: JSONEncoding.default,
                   headers: headers).responseString { response in
            switch response.result{
            case .success(_):
                print("⭐️멘토 등록 성공⭐️")
                let dataString = String(data: response.data!, encoding: .utf8)
                
                completion(true)
            default:
                print("👿멘토 등록 실패👿")
                completion(false)
            }
        }
    }
    
    
    
    // MARK: - 계정 API
    // 계정 조회 API
    //    HTTP://localhost/accounts/54
    func getAccount(accountId: Int, completion: @escaping (String) -> Void){
        let url = Config.baseURL+"/accounts/" + String(accountId)
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        let headers: HTTPHeaders = ["Accept" : "application/json",
                                    "Content-Type" : "application/json",
                                    "Authentication" : "Bearer " + accessToken!]
        var jsonDict : Dictionary<String, Any> = [String : Any]()
        AF.request(url, method: .get,  headers: headers).validate(statusCode: 200..<300).responseString { response in
            switch response.result{
                //200인 경우 성공
            case .success(_):
                do {
                    let dataString = String(data: response.data!, encoding: .utf8)
                    jsonDict = try JSONSerialization.jsonObject(with: (dataString?.data(using: .utf8))!, options: []) as! [String:Any]
                    var userName = jsonDict["name"] as! String
                    completion(userName)
                } catch {
                    print(error.localizedDescription)
                }
            default:
                print("👿계정 조회 실패👿")
                completion("")
            }
        }
    }
    
    
    
    // 내 계정 조회 및 coredata 저장
    func getMyAccount(accessToken: String,
                      completion: @escaping (Int) -> Void){
        let url = Config.baseURL+"/accounts/me"
        headers.add(name: "Authentication", value: "Bearer " + accessToken)

        var jsonDict : Dictionary<String, Any> = [String : Any]()
        AF.request(url, method: .get,  headers: headers).validate(statusCode: 200..<300).responseString { response in
            switch response.result{
                //200인 경우 성공
            case .success(_):
                do {
                    //한글 깨짐 문제 해결을 위한 string 화
                    let dataString = String(data: response.data!, encoding: .utf8)
                    
                    // 딕셔너리에 데이터 저장 실시
                    jsonDict = try JSONSerialization.jsonObject(with: (dataString?.data(using: .utf8))!, options: []) as! [String:Any]
                    
                    CoreDataManager.shared.deleteAllUsers()
                    CoreDataManager.shared
                        .saveUserEntity(accountId: jsonDict["id"] as! Int64, email: jsonDict["email"] as! String, gender: jsonDict["gender"] as! String, name: jsonDict["name"] as! String, password: nil, thumbnail: jsonDict["thumbnail"] as? String, onSuccess: { onSuccess in
                            print("⭐️내 계정 coredata 저장 성공⭐️")
                            UIViewController.changeRootViewControllerToHome()
                        })
                    UserDefaults.standard.set(jsonDict["name"] as! String, forKey: "name")
                    completion(Int(jsonDict["id"] as! Int64))
                } catch {
                    print(error.localizedDescription)
                }
            default:
                print("👿내 계정 조회 실패👿")
            }
        }
    }
    
    fileprivate func saveNewUser(accountId: Int64, email: String, gender: String, name: String, password: String, thumbnail: String?) {
        
        CoreDataManager.shared
            .saveUserEntity(accountId: accountId, email: email, gender: gender, name: name, password: password, thumbnail: thumbnail, onSuccess: { onSuccess in
                print("saved = \(onSuccess)")
            })
        User.name = name
    }
    
    // 회원탈퇴
    //HTTP://localhost/accounts/49
    func deleteUser(accountId: Int){
        let url = Config.baseURL+"/accounts/"+String(accountId)
        guard let mentoAccessToken = accessToken else {
            print("👿멘토 토큰 조회 실패👿")
            return
        }
        headers.add(name: "Authentication", value: "Bearer " + mentoAccessToken)

        AF.request(url, method: .delete, encoding: JSONEncoding.default, headers: headers).responseString { response in
            if let response = response.response{
                switch response.statusCode{
                    //200인 경우 전송 성공
                case 200:
                    print("⭐️회원가입 탈퇴 성공⭐️")
                default:
                    print("👿회원가입 탈퇴 실패👿")
                }
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
        AF.request(Config.baseURL+"/sign-up/verify-email", method: .post, parameters: param, encoding: JSONEncoding.default).responseString { response in
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
        AF.request(Config.baseURL+"/sign-up/verify-confirm-email",
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
        AF.request(Config.baseURL+"/sign-up", method: .post, parameters: param, encoding: JSONEncoding.default).responseString { response in
            switch response.result{
                //200인 경우 성공
            case .success(let data):
                var jsonDict : Dictionary<String, Any> = [String : Any]()
                do {
                    // 딕셔너리에 데이터 저장 실시
                    jsonDict = try JSONSerialization.jsonObject(with: Data(data.utf8), options: []) as! [String:Any]
                    // Get the values from the JSON object
                    
                    UserDefaults.standard.setValue(jsonDict["accountId"] as? Int64, forKey: "isAutoLogin")
                    self.accountId = jsonDict["accountId"] as? Int
                    UserDefaults.standard.set(jsonDict["accountId"], forKey: "accountId")
                    CoreDataManager.shared.deleteAllUsers()
                    self.saveNewUser(accountId: (jsonDict["accountId"] as! Int64),
                                     email: param["email"] as! String,
                                     gender: param["gender"] as! String,
                                     name: param["name"] as! String,
                                     password: param["password"] as! String,
                                     thumbnail: param["email"] as? String)
                } catch {
                    print(error.localizedDescription)
                }
                print("⭐️회원가입 성공⭐️")
                completion()
            default:
                print("👿 회원가입 실패 👿")
            }
        }
    }
    
    // MARK: - 로그인 API
    // 서버 자체 로그인 API
    // 로그인 성공
    // 1. response값인 accessToken 저장
    // 2. 내정보/ 과목 / 추천멘토 정보 불러오고 저장
    func signIn(param: Parameters,
                completion: @escaping () -> Void){
        AF.request(Config.baseURL+"/sign-in",
                   method: .post,
                   parameters: param,
                   encoding: JSONEncoding.default).responseString { response in
            switch response.result{
            case .success(let data):
                if let jsonData = data.data(using: .utf8) {
                    do {
                        if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                            UserDefaults.standard.setValue(jsonDict["accessToken"] as? String, forKey: "accessToken")
                        }
                        completion()
                    } catch {
                        // Handle error
                        print("Error: \(error.localizedDescription)")
                    }
                }
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
        AF.request(Config.baseURL+"/social/sign-in/"+domain, method: .post, parameters: param, encoding: JSONEncoding.default).responseJSON() { response in
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
    // MARK: - 멘토 API
    // 멘토 조회
    func getMentorInfo(mentoId: Int, completion: @escaping (RecommendMentor?) -> Void) {
        let url = Config.baseURL+"/mentors/\(mentoId)"
        guard let mentoAccessToken = accessToken else {
            print("👿멘토 토큰 조회 실패👿")
            return
        }
        headers.add(name: "Authentication", value: "Bearer " + mentoAccessToken)

        AF.request(url,
                   method: .get,
                   headers: headers).responseString { response in
            switch response.result{
            case .success(_):
                do{
                    let dataString = String(data: response.data!, encoding: .utf8)
                    
                    if let jsonData = dataString!.data(using: .utf8) {
                        if let jsonDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                            let mentoData = RecommendMentor(mentoId: jsonDict["id"] as! Int,
                                                            id: jsonDict["id"] as! Int,
                                                            thumbnail: jsonDict["thumbnail"] as? String,
                                                            name: jsonDict["name"] as! String,
                                                            mentoringCount: jsonDict["mentoringCount"] as? Int,
                                                            minPrice: jsonDict["minPrice"] as? Int,
                                                            maxPrice: jsonDict["maxPrice"] as? Int,
                                                            description: jsonDict["description"] as? String,
                                                            reviewCount: jsonDict["reviewCount"] as? Int,
                                                            totalReviewScore: jsonDict["totalReviewScore"] as? Int,
                                                            averageReviewScore: jsonDict["averageReviewScore"] as? Double)

                            completion(mentoData)
                        }
                    }
                }catch {
                    print(error.localizedDescription)
                }
               
            default:
                print("👿멘토 조회 실패👿")
                completion(nil)
            }
        }
    }
    
    // 멘토 과목 조회
    func getMentorSubjects(mentoId: Int, completion: @escaping (String) -> Void) {
        let url = Config.baseURL+"/mentors/\(mentoId)/extracurricular-subjects"
        guard let mentoAccessToken = accessToken else {
            print("👿멘토 토큰 조회 실패👿")
            return
        }
        headers.add(name: "Authentication", value: "Bearer " + mentoAccessToken)

        AF.request(url, method: .get,  headers: headers).responseString { response in
            switch response.result{
            case .success(_):
                do {
                    let dataString = String(data: response.data!, encoding: .utf8)
                    let data = dataString!.data(using: .utf8)!
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]{
                        UserDefaultsManager.mentoSubject = []
                        for subject in jsonArray {
                            let subjectData = MentoSubject(id: subject["id"] as! Int,
                                                           accountId: subject["accountId"] as! Int,
                                                           mentorId: subject["mentorId"] as! Int,
                                                           extracurricularSubjectCode: subject["extracurricularSubjectCode"] as! Int)
                            UserDefaultsManager.mentoSubject!.insert(subjectData, at: 0)
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            default:
                print("👿멘토 과목 조회 실패👿")
            }
        }
    }
    
    
    
    
    
    // MARK: - 채팅 - 다이렉트 (Chatting) API
    // 다이렉트 메시지를 생성
    // 다이렉트 메시지 리스트를 조회
    // 보낸거 받은거 다 로컬 디비에 저장하고, 뿌려주기
    // 최초 가입인지 아닌지 확인하는 로직 >
    // 자체 로그인시 키체인에 값이 없으면 앱 삭제 후 재로그인이므로 리스트 호출 api
    //HTTP://localhost/chats/13/messages
    // 다이렉트 메시지 리스트 조회(GET)
    //    'HTTP://localhost/direct-messages/list
    //    func getDirectMessage(param: Parameters){
    //        AF.request
    //    }
    
    
    
    
    // 다이렉트 메시지 생성
    // HTTP://localhost/direct-messages
    //    {
    //      "accountId" : 4, // 메세지 받을 Id
    //      "message" : "안녕하세요!!",
    //      "type" : "TEXT"
    //    }
    func sendDirectMessage(param: Parameters){
        guard let mentoAccessToken = accessToken else {
            print("👿멘토 토큰 조회 실패👿")
            return
        }
        headers.add(name: "Authentication", value: "Bearer " + mentoAccessToken)

        AF.request(Config.baseURL+"/direct-messages",
                   method: .post,
                   parameters: param,
                   encoding: JSONEncoding.default,
                   headers: headers).responseString { response in
            switch response.result{
                //200인 경우 성공
            case .success(let data):
                if let jsonData = data.data(using: .utf8) {
                    do {
                        let dataString = String(data: response.data!, encoding: .utf8)
                        let data = dataString!.data(using: .utf8)!
                        if let chatDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                            
                            // chattingroom 데이터 추가
                            
                            if let receiver = self.optionalAnyToDictionary(chatDict["receiver"]){
                                let chatReceiver = ChattingRoom.Receiver(id: receiver["id"] as! Int,
                                                                         name: receiver["name"] as! String)
                                let chat = ChattingRoom(id: chatDict["id"] as! Int,
                                                        senderAccountId: chatDict["senderAccountId"] as! Int,
                                                        receiver: chatReceiver,
                                                        message: chatDict["message"] as! String,
                                                        type: chatDict["type"] as! String,
                                                        createdDate: chatDict["createdDate"] as! String,
                                                        lastModifiedDate: chatDict["lastModifiedDate"] as! String)
                                UserDefaultsManager.chattingRoom!.insert(chat, at: 0)
                                print("⭐️다이렉트 메시지 전송 성공⭐️")
                            }
                        }
                    } catch {
                        // Handle error
                        print("Error: \(error.localizedDescription)")
                    }
                }
            default:
                print("👿다이렉트 메시지 전송 실패👿")
            }
        }
    }
    
    // GET : 다이렉트 메시지 리스트 조회
    // 앱 실행시 수행
    func getDirectListMessage() {
        let url = Config.baseURL+"/direct-messages/list"
        guard let mentoAccessToken = accessToken else {
            print("👿멘토 토큰 조회 실패👿")
            return
        }
        headers.add(name: "Authentication", value: "Bearer " + mentoAccessToken)

        AF.request(url,
                   method: .get,
                   headers: headers).responseString { response in
            switch response.result{
            case .success(_):
                do {
                    let dataString = String(data: response.data!, encoding: .utf8)
                    let data = dataString!.data(using: .utf8)!
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]{
                        UserDefaultsManager.chattingRoom = []
                        for chat in jsonArray{
                            if let receiver = self.optionalAnyToDictionary(chat["receiver"]) {
                                let chatReceiver = ChattingRoom.Receiver(id: receiver["id"] as! Int,
                                                                         name: receiver["name"] as! String)
                                let chat = ChattingRoom(id: chat["id"] as! Int,
                                                        senderAccountId: chat["senderAccountId"] as! Int,
                                                        receiver: chatReceiver,
                                                        message: chat["message"] as! String,
                                                        type: chat["type"] as! String,
                                                        createdDate: chat["createdDate"] as! String,
                                                        lastModifiedDate: chat["lastModifiedDate"] as! String)
                                UserDefaultsManager.chattingRoom!.insert(chat, at: 0)
                            }
                            print("⭐️메시지 리스트 조회 성공⭐️")
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            default:
                print("👿메시지 리스트 조회 실패👿")
            }
        }
    }
    
    // 특정 유저와의 다이렉트 메시지 조회 , senderAccountId : 보낸사람 AccountId
    func getDirectMessages(senderAccountId: Int) {
        let url = Config.baseURL+"/direct-messages?accountId=" + String(senderAccountId) + "&lastId=2147483647&displayCount=50"
        guard let mentoAccessToken = accessToken else {
            print("👿멘토 토큰 조회 실패👿")
            return
        }
        headers.add(name: "Authentication", value: "Bearer " + mentoAccessToken)

        AF.request(url,
                   method: .get,
                   headers: headers).responseString { response in
            switch response.result{
            case .success(_):
                do {
                    let dataString = String(data: response.data!, encoding: .utf8)
                    let data = dataString!.data(using: .utf8)!
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]{
                        UserDefaultsManager.chatting = []
                        for chat in jsonArray{
                            if let receiver = self.optionalAnyToDictionary(chat["receiver"]) {
                                let chatReceiver = ChattingRoom.Receiver(id: receiver["id"] as! Int,
                                                                         name: receiver["name"] as! String)
                                let chat = ChattingRoom(id: chat["id"] as! Int,
                                                        senderAccountId: chat["senderAccountId"] as! Int,
                                                        receiver: chatReceiver,
                                                        message: chat["message"] as! String,
                                                        type: chat["type"] as! String,
                                                        createdDate: chat["createdDate"] as! String,
                                                        lastModifiedDate: chat["lastModifiedDate"] as! String)
                                UserDefaultsManager.chatting!.insert(chat, at: 0)
                            }
                            //                            print("⭐️특정 유저의 리스트 조회 성공⭐️")
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            default:
                print("👿특정 유저의 메시지 리스트 조회 실패👿")
            }
        }
    }
    
    // MARK: - FCM API
    // PUT - 서버에 FCM token 보내기
    //request
    //    {
    //      "fcmToken" : "FCM_TOKEN"
    //    }
    func putFCMToken(fcmToken: String, accessToken: String, accountId: Int){
        let fcmParameter: Parameters = [
            "fcmToken" : fcmToken
        ]
        if KeyChain.shared.getItem(id: "accessToken") != nil{
            let headers: HTTPHeaders = ["Accept" : "application/json",
                                        "Content-Type" : "application/json",
                                        "Authentication" : "Bearer " + accessToken]
            var url = Config.baseURL + "/accounts/" + String(accountId) + "/fcm-token"
            
            AF.request(url, method: .put, parameters: fcmParameter, encoding: JSONEncoding.default, headers: headers).responseString { response in
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
    
    // MARK: - UI API
    // GET - 과목 데이터 가져오기(완료)
    // Userdefault 저장
    func getSubjects() {
        let url = Config.baseURL+"/assets/extracurricular-subjects"
        let headers: HTTPHeaders = ["Accept" : "application/json",
                                    "Content-Type" : "application/json"]
        AF.request(url, method: .get,  headers: headers).responseString { response in
            switch response.result{
            case .success(_):
                do {
                    let dataString = String(data: response.data!, encoding: .utf8)
                    let data = dataString!.data(using: .utf8)!
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]{
                        UserDefaultsManager.subjectList = []
                        for subject in jsonArray{
                            let subjectData = SubjectModel(code: subject["code"] as! Int,
                                                           value: subject["value"] as! String,
                                                           topic: subject["topic"] as! String)
                            UserDefaultsManager.subjectList!.insert(subjectData, at: 0)
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                print("⭐️과목 데이터 조회 성공⭐️")
            default:
                print("👿과목 데이터 조회 실패👿")
            }
        }
    }
    
    //GET - 추천멘토 데이터 가져오기(완료)
    // Userdefault 저장
    func getRecommendMentors(accessToken: String) {
        let url = Config.baseURL+"/mentors/recommend"

        headers.add(name: "Authentication", value: "Bearer " + accessToken)

        AF.request(url, method: .get,  headers: headers).responseString { response in
            switch response.result{
            case .success(_):
                do {
                    let dataString = String(data: response.data!, encoding: .utf8)
                    let data = dataString!.data(using: .utf8)!
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]{
                        UserDefaultsManager.recommendMentorList = []
                        for mentor in jsonArray{
                            if let dictionary = self.optionalAnyToDictionary(mentor["account"]) {
                                print(dictionary)
                                let mentoData = RecommendMentor(mentoId: mentor["id"] as! Int,
                                                                id: dictionary["id"] as! Int,
                                                                thumbnail: dictionary["thumbnail"] as? String,
                                                                name: dictionary["name"] as! String,
                                                                mentoringCount: dictionary["mentoringCount"] as? Int,
                                                                minPrice: dictionary["minPrice"] as? Int,
                                                                maxPrice: dictionary["maxPrice"] as? Int,
                                                                description: dictionary["description"] as? String,
                                                                reviewCount: dictionary["reviewCount"] as? Int,
                                                                totalReviewScore: dictionary["totalReviewScore"] as? Int,
                                                                averageReviewScore: dictionary["averageReviewScore"] as? Double)
                                
                                UserDefaultsManager.recommendMentorList!.insert(mentoData, at: 0)
                            } else {
                                print("Value is nil or cannot be converted to a dictionary.")
                            }
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                print("⭐️추천 멘토 데이터 조회 성공⭐️")
            default:
                print("👿추천 멘토 조회 실패👿")
            }
        }
    }
    
    //공지사항 API
    //    [ {
    //    "code" : 1,
    //    "title" : "안드로이드 지원 중단 안내",
    //    "contents" : "안녕하세요~",
    //    "createdDate" : "2023-05-15T01:29:20.818"
    //  } ]
    
    //    [ {
    //    "code" : 1,
    //    "title" : "iOS & iPadOS 17 Beta Release Notes",
    //    "contents" : "Devices with a large number of installed apps will display an Apple logo with progress bar for an extended period while the file system format is updated. This is a one-time migration when upgrading to iOS 17 beta for the first time. (109431767)",
    //    "createdDate" : "2023-06-06T06:30:00.000"
    //  } ]
    func getNotices() {
        let url = Config.baseURL+"/assets/notices"
        let headers: HTTPHeaders = ["Accept" : "application/json",
                                    "Content-Type" : "application/json"]
        AF.request(url, method: .get,  headers: headers).responseString { response in
            switch response.result{
            case .success(_):
                do {
                    let dataString = String(data: response.data!, encoding: .utf8)
                    let data = dataString!.data(using: .utf8)!
                    if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]{
                        UserDefaultsManager.recommendMentorList = []
                        for mentor in jsonArray{
                            if let dictionary = self.optionalAnyToDictionary(mentor["account"]) {
                                print(dictionary)
                                let mentoData = RecommendMentor(mentoId: mentor["id"] as! Int,
                                                                id: dictionary["id"] as! Int,
                                                                thumbnail: dictionary["thumbnail"] as? String,
                                                                name: dictionary["name"] as! String,
                                                                mentoringCount: dictionary["mentoringCount"] as? Int,
                                                                minPrice: dictionary["minPrice"] as? Int,
                                                                maxPrice: dictionary["maxPrice"] as? Int,
                                                                description: dictionary["description"] as? String,
                                                                reviewCount: dictionary["reviewCount"] as? Int,
                                                                totalReviewScore: dictionary["totalReviewScore"] as? Int,
                                                                averageReviewScore: dictionary["averageReviewScore"] as? Double)
                                UserDefaultsManager.recommendMentorList!.insert(mentoData, at: 0)
                            } else {
                                print("Value is nil or cannot be converted to a dictionary.")
                            }
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
                print("⭐️추천 멘토 데이터 조회 성공⭐️")
            default:
                print("👿추천 멘토 조회 실패👿")
            }
        }
    }
    
    
    
    func optionalAnyToDictionary(_ value: Any?) -> [String: Any]? {
        guard let value = value else {
            return nil // Optional value is nil, return nil dictionary
        }
        
        if let dictionary = value as? [String: Any] {
            return dictionary // Value is already a dictionary, return as is
        }
        
        if let data = try? JSONSerialization.data(withJSONObject: value, options: []),
           let dictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            return dictionary // Value can be serialized to a dictionary, return the serialized dictionary
        }
        
        return nil // Value cannot be converted to a dictionary, return nil
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
        let url = Config.baseURL + "/search/" + "\(query)/\(page)"
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
        //        let url = Config.baseURL+"//accounts/accountId/email"
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
