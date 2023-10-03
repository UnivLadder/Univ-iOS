//
//  AccountsRegisterViewController.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2021/12/06.
//

import UIKit
import AuthenticationServices
import Alamofire

class AccountsRegisterViewController: UIViewController {
    
    var userModel = UserModel() // 인스턴스 생성
    
    //이름
    @IBOutlet weak var registerName: UITextField!
    
    //email
    @IBOutlet weak var registerEmailTxt: UITextField!
    //email 인증번호 전송 버튼
    @IBOutlet weak var emailAuthBtn: UIButton!
    @IBOutlet weak var emailAuthErrorLabel: UILabel!
    
    //email 인증번호
    @IBOutlet weak var authView: UIView!
    @IBOutlet weak var emailAuthNumTxt: UITextField!
    //email 인증번호 확인 버튼
    @IBOutlet weak var emailAuthNumCheckBtn: UIButton!
    
    //비밀번호
    @IBOutlet weak var registerPassword: UITextField!
    @IBOutlet weak var registerPassword2: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    //성별
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    
    @IBOutlet weak var nextBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    
    
    
    @IBAction func maleBtn(_ sender: Any) {
        maleBtn.backgroundColor = #colorLiteral(red: 0.4406229556, green: 0.350309521, blue: 0.9307079911, alpha: 1)
        maleBtn.tintColor = UIColor.white
        femaleBtn.backgroundColor = UIColor.white
        femaleBtn.tintColor = #colorLiteral(red: 0.4406229556, green: 0.350309521, blue: 0.9307079911, alpha: 1)
        User.gender = "MAN"
    }
    
    @IBAction func femaleBtn(_ sender: Any) {
        femaleBtn.backgroundColor = #colorLiteral(red: 0.4406229556, green: 0.350309521, blue: 0.9307079911, alpha: 1)
        femaleBtn.tintColor = UIColor.white
        maleBtn.backgroundColor = UIColor.white
        maleBtn.tintColor = #colorLiteral(red: 0.4406229556, green: 0.350309521, blue: 0.9307079911, alpha: 1)
        User.gender = "WOMAN"
    }
    
    @IBAction func saveBtnAction(_ sender: Any) {
        
    }

    //회원가입
    //1. 자체 회원가입
    //2. 소셜 회원가입
    //소셜 화면 > 소셜화면에서 동의 받음 > 우리 화면 본인인증
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewComponents()
        // Do any additional setup after loading the view.
        //        emailAuthNum.isHidden = true
        authView.isHidden = true
        
        //        registerPassword.frame.origin.y = registerPassword.frame.origin.y-80
    }
    
    // MARK: - View Components
    func viewComponents() {
        if #available(iOS 12.0, *) {
            registerPassword.textContentType = .oneTimeCode
            registerPassword2.textContentType = .oneTimeCode
        }
        
        maleBtn.backgroundColor = UIColor.white
        maleBtn.layer.borderWidth = 1
        maleBtn.layer.borderColor = Colors.mainPurple.color.cgColor
        maleBtn.layer.cornerRadius = 10
        
        femaleBtn.backgroundColor = UIColor.white
        femaleBtn.layer.borderWidth = 1
        femaleBtn.layer.borderColor = Colors.mainPurple.color.cgColor
        femaleBtn.layer.cornerRadius = 10
    
        nextBtn.layer.cornerRadius = 10
        nextBtn.tintColor = UIColor.white
        nextBtn.setTitle(NSLocalizedString("nextBtnTitle", comment: ""), for: .normal)
        
        emailAuthErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
        
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
    
    //화면 터치 감지
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    // 키보드 올라갔다는 알림을 받으면 실행되는 메서드
    @objc func keyboardWillShow(_ sender:Notification){
        self.view.frame.origin.y = -80
    }
    // 키보드 내려갔다는 알림을 받으면 실행되는 메서드
    @objc func keyboardWillHide(_ sender:Notification){
        self.view.frame.origin.y = 0
    }
    
    // MARK: - Action 1. email 인증
    // 입력한 이메일로 인증메일 전송 Action
    //emailAuthBtn
    @IBAction func emailAuthAction(_ sender: Any) {
        guard let email = registerEmailTxt.text, !email.isEmpty else { return }
        // 이메일 validate 처리
        if userModel.isValidEmail(id: email){
            //nil 처리 추가
            //emailErrorLabel.text = " "
            if let removable = self.view.viewWithTag(100) {
                removable.removeFromSuperview()
            }
            authView.isHidden = false
            emailAuthBtn.setTitle("재전송", for: .normal)
            let params = ["email" : email]
            // 인증번호 전송 api 수행(성공 콜백받는 형태로 바꾸기)
            APIService.shared.postEmailAuth(param: params)
            
            let alert = UIAlertController(title:"이메일 인증번호 전송 완료",
                                          message: "메일로 받은 인증번호를 입력해주세요.",
                                          preferredStyle: UIAlertController.Style.alert)
            let buttonLabel = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(buttonLabel)
            present(alert,animated: true,completion: nil)
        }
        // 이메일 validate - ERROR
        else {
            //            shakeTextField(textField: registerEmail)
            emailAuthErrorLabel.text = "잘못된 형식의 이메일입니다."
            emailAuthErrorLabel.textColor = UIColor.red
            emailAuthErrorLabel.tag = 100
            emailAuthErrorLabel.isHidden = false
        }
    }
    
    // 메일 인증번호 validate Action
    @IBAction func emailAuthNumCheckAction(_ sender: Any) {
        var alert = UIAlertController()
        guard let email = registerEmailTxt.text, !email.isEmpty else { return }
        if let emailToken = emailAuthNumTxt.text{
            let params = ["email":email, "token" : emailToken]
            APIService.shared.emailAuthNumCheckAction(param: params){ [self] response in
                if response{
                    //이메일 인증 성공
                    //1. 경고창 내용 만들기
                    alert = UIAlertController(title:"이메일 인증 성공",
                                              message: "남은 정보들을 입력하세요.",
                                              preferredStyle: UIAlertController.Style.alert)
                    //2. 확인 버튼 만들기
                    let buttonLabel = UIAlertAction(title: "확인", style: .default, handler: nil)
                    //3. 확인 버튼을 경고창에 추가하기
                    alert.addAction(buttonLabel)
                    //4. 경고창 보이기
                    self.present(alert,animated: true,completion: nil)
                    self.emailAuthNumCheckBtn.setTitle("인증 완료", for: .normal)
                    self.emailAuthNumCheckBtn.tintColor = #colorLiteral(red: 0, green: 0.5603182912, blue: 0, alpha: 1)
                    
                    // user email 정보 메모리 저장
                    User.email = registerEmailTxt.text!
                    UserDefaults.standard.setValue(true, forKey: "emailAuth")
                }else{
                    //이메일 인증 실패
                    alert = UIAlertController(title:"이메일 인증 실패",
                                              message: "인증번호를 다시 확인해주세요.",
                                              preferredStyle: UIAlertController.Style.alert)
                    //2. 확인 버튼 만들기
                    let buttonLabel = UIAlertAction(title: "확인", style: .default, handler: nil)
                    //3. 확인 버튼을 경고창에 추가하기
                    alert.addAction(buttonLabel)
                    //4. 경고창 보이기
                    self.present(alert,animated: true,completion: nil)
                    self.emailAuthNumCheckBtn.setTitle("재확인", for: .normal)
                    self.emailAuthNumCheckBtn.tintColor = UIColor.red
                    
                    UserDefaults.standard.setValue(false, forKey: "emailAuth")
                }
            }
        }
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertController(title: "메일을 전송 실패", message: "아이폰 이메일 설정을 확인하고 다시 시도해주세요.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default) {
            (action) in
            print("확인")
        }
        sendMailErrorAlert.addAction(confirmAction)
        self.present(sendMailErrorAlert, animated: true, completion: nil)
    }
    
    // 인증번호 validate처리
    @IBAction func authCheckBtn(_ sender: Any) {
        
    }
    
    // MARK: - Action 2. 회원가입
    // 다음 버튼 Action
    // 1. textfield 파라미터 validate
    // 2. 비밀번호 validate
    // 3. 이메일 인증 성공하는 경우(emailAuth가 true인 경우)
    // 위 경우가 모두 성공인 경우, sign up API 수행> coredata 저장 > 로그인 화면으로 돌아감
    @IBAction func registerCompleteAction(_ sender: Any) {

        // 1. textfield 파라미터 validate
        // 옵셔널 바인딩 & 예외 처리 Textfield가 빈문자열이 아니고, nil이 아닐 때
        guard let name = registerName.text, !name.isEmpty else { return }
        guard let password = registerPassword.text, !password.isEmpty else { return }
        guard let password2 = registerPassword2.text, !password.isEmpty else { return }

        // 2. 비밀번호 validate 처리
        // 1-1. 비밀번호 형식 validate
        if userModel.isValidPassword(pwd: password){
            if let removable = self.view.viewWithTag(101) {
                removable.removeFromSuperview()
            }
        }
        else {
            //            shakeTextField(textField: registerPassword)
            passwordErrorLabel.text = "비밀번호를 다시 입력해주세요."
            passwordErrorLabel.textColor = UIColor.red
            passwordErrorLabel.tag = 101
            passwordErrorLabel.isHidden = false
        }

        if userModel.isValidPassword(pwd: password2){
            if let removable = self.view.viewWithTag(101) {
                removable.removeFromSuperview()
            }
            // 1-2. 비밀번호 두개 비교
            if registerPassword.text ==
                registerPassword2.text{
                // 3. 이메일 인증 성공하는 경우(emailAuth가 true인 경우)
                if UserDefaults.standard.bool(forKey: "emailAuth"){

                    // 실데이터
                    let registerUserParam: Parameters = [
                        "email" : User.email,
                        "password" : password2,
                        "name" : name,
                        "thumbnail" : "",
                        "gender" : User.gender
                    ]

                    APIService.shared.signUp(param: registerUserParam, completion: {
                        let alert = UIAlertController(title: "💙 회원가입 성공 💙", message: "로그인 하세요.", preferredStyle: .alert)
                        let buttonLabel = UIAlertAction(title: "확인", style: .default, handler: {_ in
                            self.dismiss(animated:true, completion: nil)
                        })
                        alert.addAction(buttonLabel)
                        self.present(alert, animated: true, completion: nil)
                    })
                }else{
                    let alert = UIAlertController(title: "이메일 인증 실패", message: "이메일 인증 성공 후 다시 시도해주세요.", preferredStyle: .alert)
                    let buttonLabel = UIAlertAction(title: "확인", style: .default, handler: nil)
                    alert.addAction(buttonLabel)
                    present(alert,animated: true,completion: nil)
                }
            }
            else {
                passwordErrorLabel.text = "두 비밀번호가 일치하지 않습니다."
                passwordErrorLabel.textColor = UIColor.red
                passwordErrorLabel.tag = 101
                passwordErrorLabel.isHidden = false
                //                shakeTextField(textField: registerPassword)
                //                shakeTextField(textField: registerPassword2)
            }
        }
        else {
            //            shakeTextField(textField: registerPassword)
            passwordErrorLabel.text = "비밀번호를 다시 입력해주세요."
            passwordErrorLabel.textColor = UIColor.red
            passwordErrorLabel.tag = 101
            passwordErrorLabel.isHidden = false
        }
    }
    
    fileprivate func saveNewUser(_ accountId: Int, email: String, gender: String, name: String, password: String, thumbnail: String?, mentee: Bool, mentor: Bool) {
        CoreDataManager.shared
            .saveUserEntity(accountId: accountId, email: email, gender: gender, name: name, password: password, thumbnail: thumbnail, mentee: mentee, mentor: mentor,  onSuccess: { onSuccess in
                print("saved = \(onSuccess)")
            })
        User.name = name
    }
    
    // 회원가입이 되어있는 경우 로그인 화면으로 돌아가는 Action
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // TextField 흔들기 애니메이션
    //    func shakeTextField(textField: UITextField){
    //        UIView.animate(withDuration: 0.2, animations: {
    //            textField.frame.origin.x -= 10
    //        }, completion: { _ in
    //            UIView.animate(withDuration: 0.2, animations: {
    //                textField.frame.origin.x += 20
    //            }, completion: { _ in
    //                UIView.animate(withDuration: 0.2, animations: {
    //                    textField.frame.origin.x -= 20
    //                })
    //            })
    //        })
    //    }
}
