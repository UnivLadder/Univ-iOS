//
//  AccountsMainViewController.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2021/12/06.
//

import UIKit
import AuthenticationServices
import GoogleSignIn
import KakaoSDKUser
import Firebase
import Alamofire

// 로그인 화면
class AccountsMainViewController: UIViewController, ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate, UITextFieldDelegate, StoryboardInitializable {
    
    static var storyboardName: String = "Accounts"
    static var storyboardID: String = "Accounts"
    
    var userModel = UserModel() // 인스턴스 생성
    
    let logInError: Int = 0
    var isAutoLogin: Bool = false
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var autoLogInCheckmark: UIButton!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    
    @IBOutlet weak var serverLoginBtn: UIButton!
    @IBOutlet weak var googleLogInBtn: UIButton!
    @IBOutlet weak var appleLogInBtn: UIButton!
    @IBOutlet weak var kakaoLoginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewComponents()
    }
    
    // MARK: - 로그인 Action
    //1. 자체 로그인 2.구글 소셜 로그인 3.애플 소셜 로그인
    
    //1. 자체 로그인 - 토큰 저장(키체인)
    // + coredata 없는 경우 내 계정 조회 response 값 저장
    //    "username" : "sign-in@gmail.com",
    //    "password" : "password"
    
    /// 로그인 수행 action 메소드
    /// - Parameter sender: sender
    @IBAction func logInAction(_ sender: Any) {
        // 옵셔널 바인딩 & 예외 처리 : Textfield가 빈문자열이 아니고, nil이 아닐 때
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        
        //        if self.checkLogInInfo(email: email, password: password) {
        self.serverLogIn(email: email, password: password)
        //        }
    }
    
    /// 로그인 입력 데이터 형식 체크 메소드
    /// - Parameters:
    ///   - email: 로그인 이메일
    ///   - password: 로그인 비밀번호
    /// - Returns: bool type, true 인 경우 서버 통신 수행
    func checkLogInInfo(email: String, password: String) -> Bool {
        var res = false
        
        // 이메일 형식 오류
        if userModel.isValidEmail(id: email){
            //nil 처리 추가
            //emailErrorLabel.text = " "
            if let removable = self.view.viewWithTag(100) {
                removable.removeFromSuperview()
                res = true
            }
        }
        else {
            shakeTextField(textField: emailTextField)
            emailErrorLabel.text = "잘못된 형식의 이메일입니다."
            emailErrorLabel.textColor = UIColor.red
            emailErrorLabel.tag = 100
            emailErrorLabel.isHidden = false
            res = false
        }
        
        // 비밀번호 형식 오류
        if userModel.isValidPassword(pwd: password){
            if let removable = self.view.viewWithTag(101) {
                removable.removeFromSuperview()
                res = true
            }
        }
        else{
            shakeTextField(textField: passwordTextField)
            passwordErrorLabel.text = "비밀번호를 다시 입력해주세요."
            passwordErrorLabel.textColor = UIColor.red
            passwordErrorLabel.tag = 101
            passwordErrorLabel.isHidden = false
            res = false
        }
        return res
    }
    
    
    func serverLogIn(email: String, password: String) {
        //실 data
        let params = ["username" : email,
                      "password" : password]
        
        APIService.shared.signIn(param: params, completion: {
            if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
                
                // 자동 로그인 설정 값 저장
                if self.isAutoLogin == true {
                    UserDefaults.standard.setValue(true, forKey: "isAutoLogin")
                }else{
                    UserDefaults.standard.setValue(false, forKey: "isAutoLogin")
                }
                
                // 추천 멘토 정보 불러옴
                APIService.shared.getRecommendMentors(accessToken: accessToken)
                
                // 키체인 저장
                if KeyChain.shared.addItem(id: "accessToken", token: accessToken){
                    print("토큰 : \(accessToken)")
                }else{
                    print("👿키체인 저장 실패👿")
                }
                
                // 유저의 채팅 리스트 불러오기
                DispatchQueue.global().async {
                    APIService.shared.getDirectListMessage(accessToken: accessToken, completion: { res in
                        
                    })
                }

                
                // 내 계정 조회
                APIService.shared.getMyAccount(accessToken: accessToken, completion: { accountId in
                    UserDefaults.standard.setValue(accountId, forKey: "accountId")
                    // 메인화면 이동
                    if accountId > 0 {
                        UIViewController.changeRootViewControllerToHome()
                        // FCM 토큰 저장
                        if let fcmToken = UserDefaults.standard.string(forKey: "fcmToken") {
                            APIService.shared.putFCMToken(fcmToken: fcmToken, accessToken: accessToken, accountId: accountId)
                            print("accountId = \(accountId)")
                        }
                    }
                })
            }else{
                let alert = UIAlertController(title:"👿로그인 실패👿",
                                              message: "로그인 정보를 확인하세요.",
                                              preferredStyle: UIAlertController.Style.alert)
                let buttonLabel = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(buttonLabel)
                self.present(alert,animated: true,completion: nil)
            }
        })
    }
    
    // 자동 로그인 액션
    @IBAction func autoLoginAction(_ sender: UIButton) {
        // auto login 선택 여부
        sender.isSelected = !sender.isSelected
        if sender.isSelected == true{
            // 자동 로그인 실행
            self.isAutoLogin = true
            autoLogInCheckmark.setImage(UIImage(named: "checkBoxFilled.png"), for: .normal)
        }else{
            //자동 로그인 안함
            self.isAutoLogin = false
            autoLogInCheckmark.setImage(UIImage(named: "checkBox.png"), for: .normal)
        }
    }
    
    // TextField 흔들기 애니메이션
    func shakeTextField(textField: UITextField) -> Void{
        UIView.animate(withDuration: 0.2, animations: {
            textField.frame.origin.x -= 10
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                textField.frame.origin.x += 20
            }, completion: { _ in
                UIView.animate(withDuration: 0.2, animations: {
                    textField.frame.origin.x -= 20
                })
            })
        })
    }
    
    fileprivate func saveNewUser(_ accountId: Int, email: String, gender: String, name: String, password: String, thumbnail: String?, mentee: Bool, mentor: Bool) {
        CoreDataManager.shared
            .saveUserEntity(accountId: accountId, email: email, gender: gender, name: name, password: password, thumbnail: thumbnail, mentee: mentee, mentor: mentor,  onSuccess: { onSuccess in
                UIViewController.changeRootViewControllerToHome()
            })
        User.name = name
    }
    
    //소셜 로그인 - 1. 카카오
    @IBAction func kakaoLogInAction(_ sender: Any) {
        // 자동 로그인 설정 값 저장
        if self.isAutoLogin == true {
            UserDefaults.standard.setValue(true, forKey: "isAutoLogin")
        }else{
            UserDefaults.standard.setValue(false, forKey: "isAutoLogin")
        }
        
        // 카카오톡 설치 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
                if let error = error {
                    print(error)
                }
                else {
                    if let oauthToken = oauthToken{
                        LoginDataModel.token = oauthToken.accessToken
                        // kakaotalk login post
                        APIService.shared.signinSocial(param: LoginDataModel.registeParam, domain: "kakao", completion: { restoken in
                            APIService.shared.getMyAccount(accessToken: restoken, completion: { accountId in
                                UserDefaults.standard.setValue(accountId, forKey: "accountId")
                                self.getKakaoAccount(completion: { myEmail, myNickName   in
                                    // 이름, 이메일 저장
                                    let parameter: Parameters = [
                                        "email": myEmail ?? "",
                                        "name" : myNickName ?? "",
                                    ]
                                    
                                    APIService.shared.modifyMyAccount(accessToken: restoken,
                                                                      accountId: UserDefaults.standard.integer(forKey: "accountId"),
                                                                      param: parameter,
                                                                      completion: { res in
                                        CoreDataManager.shared.deleteAllUsers()
                                        self.saveNewUser(accountId,
                                                         email: myEmail,
                                                         gender: "",
                                                         name: myNickName,
                                                         password: "",
                                                         thumbnail: "",
                                                         mentee: true,
                                                         mentor: false
                                        )
                                    })
                                })
                            })
                        })
                        print("kakao accessToken : \(oauthToken.accessToken)")
                    } else {
                        print("Error : User Data Not Found")
                    }
                }
            }
        }
    }
    
    // 카카오 계정 정보 가져오기
    func getKakaoAccount(completion: @escaping (String, String) -> Void) {
        var myEmail = ""
        var myNickName = ""
        
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
            }
            else {
                _ = user
                if let email = user?.kakaoAccount?.email{
                    myEmail = email
                }
                if let nickName = user?.kakaoAccount?.profile?.nickname{
                    myNickName = nickName
                }
                completion(myEmail, myNickName)
            }
        }
    }
    
    //소셜 로그인 - 2. 구글
    @IBAction func googleLogInAction(_ sender: Any) {
        // 자동 로그인 설정 값 저장
        if self.isAutoLogin == true {
            UserDefaults.standard.setValue(true, forKey: "isAutoLogin")
        }else{
            UserDefaults.standard.setValue(false, forKey: "isAutoLogin")
        }
        
        // GIDSignIn config 객체 설정
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [weak self] signInResult, _ in
            guard let self,
                  let result = signInResult,
                  let token = result.user.idToken?.tokenString,
                  let email = result.user.profile?.email,
                  let nickName = result.user.profile?.name
                    
            else { return }
            // 서버에 토큰을 보내기. 이 때 idToken, accessToken 차이에 주의할 것
            LoginDataModel.token = token
            // google login post
            APIService.shared.signinSocial(param: LoginDataModel.registeParam, domain: "google", completion: { restoken in
                APIService.shared.getMyAccount(accessToken: restoken, completion: { accountId in
                    UserDefaults.standard.setValue(accountId, forKey: "accountId")
                    // 이름, 이메일 저장
                    let parameter: Parameters = [
                        "email": email ?? "",
                        "name" : nickName ?? "",
                    ]
                    
                    APIService.shared.modifyMyAccount(accessToken: restoken,
                                                      accountId: UserDefaults.standard.integer(forKey: "accountId"),
                                                      param: parameter,
                                                      completion: { res in
                        CoreDataManager.shared.deleteAllUsers()
                        self.saveNewUser(accountId,
                                         email: email,
                                         gender: "",
                                         name: nickName,
                                         password: "",
                                         thumbnail: "",
                                         mentee: true,
                                         mentor: false
                        )
                    })
                })
            })
        }
    }
    
    
    //소셜 로그인 - 3. 애플
    @IBAction func appleLogIn(_ sender: Any) {
        // 자동 로그인 설정 값 저장
        if self.isAutoLogin == true {
            UserDefaults.standard.setValue(true, forKey: "isAutoLogin")
        }else{
            UserDefaults.standard.setValue(false, forKey: "isAutoLogin")
        }
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    // Apple ID 연동 성공 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
            // Apple ID
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            // 계정 정보 가져오기
            // 애플은 최초 로그인때만 정보 줌;;
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            // accessToken (Data -> 아스키 인코딩 -> 스트링)
            let accessToken = String(data: appleIDCredential.identityToken!, encoding: .ascii) ?? ""
            LoginDataModel.token = accessToken
            
            // apple login post
            //
            APIService.shared.signinSocial(param: LoginDataModel.registeParam, domain: "apple", completion: { res in
                APIService.shared.getMyAccount(accessToken: res, completion: { accountId in
                    UserDefaults.standard.setValue(accountId, forKey: "accountId")
                    
                    // 이름, 이메일 저장
                    let parameter: Parameters = [
                        "email": "\(email ?? "")",
                        "name" : "\((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))",
                    ]
                    
                    APIService.shared.modifyMyAccount(accessToken: accessToken,
                                                      accountId: UserDefaults.standard.integer(forKey: "accountId"),
                                                      param: parameter,
                                                      completion: { res in
                        CoreDataManager.shared.deleteAllUsers()
                        self.saveNewUser(accountId,
                                         email: "\(email ?? "")",
                                         gender: "",
                                         name: "\((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))",
                                         password: "",
                                         thumbnail: "",
                                         mentee: true,
                                         mentor: false
                        )
                    })
                })
            })
        default:
            break
        }
    }
    
    // Apple ID 연동 실패 시 - 에러코드 정제 필요
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print(error)
        let alert = UIAlertController()
        alert.title = "ERROR"
        
        // Handle error.
        switch logInError{
            // 버전이 13.0 미만인 경우
        case 1:
            alert.message = "애플 로그인은 iOS 13.0 이상부터 가능합니다."
        default:
            alert.message = "\(error)"
            break
        }
    }
    
    @IBAction func moveToRegist(_ sender: Any) {
        performSegue(withIdentifier: "toRegist", sender: nil)
    }
    
    // MARK: - View Components
    func viewComponents(){
        serverLoginBtn.layer.cornerRadius = 10
        let imageView = UIImageView();
        let image = UIImage(named: "emailIcon.png");
        imageView.image = image;
        emailTextField.leftView = imageView;
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        
        //로그인 버튼
        googleLogInBtn.layer.borderWidth = 1
        googleLogInBtn.layer.borderColor = UIColor.lightGray.cgColor
        googleLogInBtn.layer.cornerRadius = 10
        
        appleLogInBtn.layer.borderWidth = 1
        appleLogInBtn.layer.borderColor = UIColor.lightGray.cgColor
        appleLogInBtn.layer.cornerRadius = 10
        
        kakaoLoginBtn.layer.cornerRadius = 10
        kakaoLoginBtn.layer.borderWidth = 1
        kakaoLoginBtn.layer.borderColor = UIColor.lightGray.cgColor
        if let image = UIImage(named: "KakaoTalk.png") {
            let image2 = image.withRoundedCorners(radius: 15)!
            kakaoLoginBtn.setImage(image2, for: .normal)
        }
        
        //텍스트필드Btn.backgroundColor = UIColor.whiteb
        emailTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.clearsOnBeginEditing = true
        passwordTextField.clearsOnBeginEditing = true
        self.emailTextField.addTarget(self, action: #selector(self.textFieldDidChange1(_:)), for: .editingChanged)
        self.passwordTextField.addTarget(self, action: #selector(self.textFieldDidChange2(_:)), for: .editingChanged)
        
        //        emailTextField.addleftimage(image: UIImage(named: "emailIcon.png")!)
        
        //키패드 제어
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        
    }
    //키보드 올라갔다는 알림을 받으면 실행되는 메서드
    @objc func keyboardWillShow(_ sender:Notification){
        self.view.frame.origin.y = -80
    }
    //키보드 내려갔다는 알림을 받으면 실행되는 메서드
    @objc func keyboardWillHide(_ sender:Notification){
        self.view.frame.origin.y = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    //텍스트필드 값 변경 감지
    @objc func textFieldDidChange1(_ sender: Any?) {
        emailTextField.clearsOnBeginEditing = false
    }
    @objc func textFieldDidChange2(_ sender: Any?) {
        passwordTextField.clearsOnBeginEditing = false
    }
}


@IBDesignable
class DesignableUITextField: UITextField {
    
    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable var leftPadding: CGFloat = 0
    
    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            imageView.contentMode = .scaleAspectFit
            imageView.image = image
            imageView.tintColor = color
            leftView = imageView
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }
        
        // Placeholder text color
        attributedPlaceholder = NSAttributedString(string: placeholder != nil ?  placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: color])
    }
}

extension UIImage {
    // image with rounded corners
    public func withRoundedCorners(radius: CGFloat? = nil) -> UIImage? {
        let maxRadius = min(size.width, size.height) / 2
        let cornerRadius: CGFloat
        if let radius = radius, radius > 0 && radius <= maxRadius {
            cornerRadius = radius
        } else {
            cornerRadius = maxRadius
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let rect = CGRect(origin: .zero, size: size)
        UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius).addClip()
        draw(in: rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
}
