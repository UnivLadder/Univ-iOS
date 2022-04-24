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
    var values: [String] = [""]
    
    func getSubjects() {
        AF.request(Config.baseURL+"assets/extracurricular-subjects", method: .get)
            .validate().responseData{ response in
                switch response.result{
                case .success(let value):
                    do {
                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                        let SubjectModel = try JSONDecoder().decode(SubjectModel.self, from: data)
                    }
                    catch {
                    }
                case .failure(let error):
                    break;
                }
            }
    }
    //    func getSubjects() {
    //        AF.request(Config.baseURL+"assets/extracurricular-subjects", method: .get)
    //            .validate().responseData{ response in
    //                switch response.result{
    //                case .success:
    //                    if let jsonData = response.data {
    //                        let jsonDecoder = JSONDecoder()
    //                        do {
    //                            let subjects = try jsonDecoder.decode([SubjectModel].self, from: jsonData)
    //
    //
    //
    ////                            print(subjects)
    ////                            completion(subjects, nil)
    //                        }catch let error{
    //                            print(error.localizedDescription)
    ////                            completion(nil, error)
    //                        }
    //                    }
    //                case .failure:
    //                    print("error : \(response.error!)")
    //                }
    //            }
    
    
    
    
    
    
    
    
    //func getSubjects() {
    //    AF.request(Config.baseURL+"assets/extracurricular-subjects", method: .get)
    //        .validate().responseData{ response in
    //            switch response.result{
    //            case .success(let value):
    //                do {
    //                    let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
    //                    let SubjectModel = try JSONDecoder().decode(SubjectModel.self, from: data)
    //                    //예){"email" : "hi", "result" : "성공"} print("email : \(userlists.email)") print("result : \(userlists.result)")
    //
    //                }
    //                catch {
    //
    //                }
    //            case .failure(let error):
    //                break;
    //
    //
    //                //                        let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
    //                //                        let userlists = try JSONDecoder().decode(SubjectModel.self, from: data)
    //                //                        if let data = response.data {
    //                //                            let json1 = JSON(data)
    //                //                            if let siArray = json1.array {
    //                //                                var res: [SubjectModel] = []
    //                //                                let obj = SubjectModel.self
    //                //                                for i in 0..<siArray.count {
    //                //
    //                ////                                    let value = siArray[i]["value"]
    //                //    //                                values.append(value.stringValue)
    //                //
    //                ////                                    self.values.append(siArray[i]["value"].stringValue)
    //                //                                    //json1에서 "value"만 가져옴.
    //                //                                }
    //                //                            }
    //                ////                            print(self.values)
    //                //                        }
    //                //                    case .failure:
    //                //                        print("error : \(response.error!)")
    //            }
    //        }
    //}
    
    //GET - 과목 데이터
    //    func getSubjects() {
    //        AF.request(Config.baseURL+"assets/extracurricular-subjects",
    //                   method: .get,
    //                   parameters: nil,
    //                   encoding: JSONEncoding.default)
    //        .responseData { response in
    //            switch response.result {
    //            case .success(let value):
    //
    //
    //                if let res = String(data: value, encoding: .utf8) as? Array<Any>{
    //                    for i in res{
    //                        print("i번째 : \(res)")
    //                    }
    //                }
    //
    //                print("response : \(String(data: value, encoding: .utf8)!)")
    //            case .failure(let error):
    //                print(error)
    //                //                    completion(nil)
    //            }
    //            //            if let data = try! response.result.get() as? [String: Any] {
    //            //                //                    print(Config.baseURL+"sign-up")
    //            //                print(data)
    //            //            }
    //            //            print("json.result : \(response.result)")
    //
    //        }
    //    }
    //
    
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
                    self.accessToken = String(describing: data["accessToken"]!)
                    //토큰 로컬 저장
                    if let accessToken = self.accessToken {
                        UserInfo.accessToken = accessToken
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
    
    //    func registeredCheck(parameters: Parameters ,completion: @escaping (_ result: String) -> (Void)){
    //
    //        AF.request(url,
    //                   method: .post,
    //                   parameters: param)
    ////            .responseDecodable(completionHandler:     { (response: DataResponse<ResultUser>, AFError>) in
    ////                completion(response.result)
    ////    })
    //
    //    }
    
    
    //    class APIClient {
    //        static func login(email: String, password: String, completion:@escaping (Result<User, AFError>)->Void) {
    //            AF.request(APIRouter.login(email: email, password: password))
    //                     .responseDecodable { (response: DataResponse<User, AFError>) in
    //                        completion(response.result)
    //            }
    //        }
    //    }
    
}
