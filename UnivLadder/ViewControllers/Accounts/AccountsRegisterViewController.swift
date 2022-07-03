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
    @IBOutlet weak var registerEmail: UITextField!
    @IBOutlet weak var authSendBtn: UIButton!
    @IBOutlet weak var emailErrorLabel: UILabel!
    
    //인증번호
    @IBOutlet weak var authView: UIView!
    @IBOutlet weak var emailAuthNum: UITextField!
    @IBOutlet weak var authCheckBtn: UIButton!
    
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
        registerPassword.frame.origin.y = registerPassword.frame.origin.y-80
    }
    
    // MARK: - View Components
    func viewComponents() {
        maleBtn.backgroundColor = UIColor.white
        maleBtn.layer.borderWidth = 1
        maleBtn.layer.borderColor = Colors.mainPurple.color.cgColor
        maleBtn.layer.cornerRadius = 10
        
        femaleBtn.backgroundColor = UIColor.white
        femaleBtn.layer.borderWidth = 1
        femaleBtn.layer.borderColor = Colors.mainPurple.color.cgColor
        femaleBtn.layer.cornerRadius = 10
        
        emailErrorLabel.isHidden = true
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
    
    // 입력한 이메일로 인증메일 전송
    @IBAction func sendNumToEmail(_ sender: Any) {
        authView.isHidden = false
        authSendBtn.setTitle("재전송", for: .normal)
        guard let email = registerEmail.text, !email.isEmpty else { return }
        
        // 이메일 validate 처리
        if userModel.isValidEmail(id: email){
            //nil 처리 추가
            //emailErrorLabel.text = " "
            if let removable = self.view.viewWithTag(100) {
                removable.removeFromSuperview()
            }
            // 인증번호 전송
            APIService.shared.putEmailAuth(with: email)
        }
        // 이메일 validate - ERROR
        else {
            shakeTextField(textField: registerEmail)
            emailErrorLabel.text = "잘못된 형식의 이메일입니다."
            emailErrorLabel.textColor = UIColor.red
            emailErrorLabel.tag = 100
            emailErrorLabel.isHidden = false
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

    // 비밀번호 validate & 회원가입 완료
    @IBAction func registerCompleteAction(_ sender: Any) {
        // 옵셔널 바인딩 & 예외 처리 : Textfield가 빈문자열이 아니고, nil이 아닐 때
        guard let name = registerName.text, !name.isEmpty else { return }

        guard let password = registerPassword.text, !password.isEmpty else { return }
        guard let password2 = registerPassword2.text, !password.isEmpty else { return }
        
        // 1. 비밀번호 validate 처리
        // 1-1. 비밀번호 형식 validate
        if userModel.isValidPassword(pwd: password){
            if let removable = self.view.viewWithTag(101) {
                removable.removeFromSuperview()
            }
        }
        else {
            shakeTextField(textField: registerPassword)
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
                //성공
            }
            else {
                passwordErrorLabel.text = "두 비밀번호가 일치하지 않습니다."
                passwordErrorLabel.textColor = UIColor.red
                passwordErrorLabel.tag = 101
                passwordErrorLabel.isHidden = false
                shakeTextField(textField: registerPassword)
                shakeTextField(textField: registerPassword2)
            }
        }
        else {
            shakeTextField(textField: registerPassword)
            passwordErrorLabel.text = "비밀번호를 다시 입력해주세요."
            passwordErrorLabel.textColor = UIColor.red
            passwordErrorLabel.tag = 101
            passwordErrorLabel.isHidden = false
        }
        
        //서버 전송
        //완료 후 Main 화면 전환
        //        let registeParam: Parameters = [
        //            "email" : email,
        //            "password" : password2,
        //            "name" : name,
        //            "thumbnail" : "THUMBNAIL",
        //            "gender" : "WOMAN"
        //        ]
        
        //dummy test
        let registeParam: Parameters = [
            "email" : "test4@gmail.com",
            "password" : "PASSWORD",
            "name" : "이연",
            "thumbnail" : "THUMBNAIL",
            "gender" : User.gender
        ]
        print(registeParam)
        APIService.shared.signup(param: registeParam)
    }
    
    //다시 로그인 화면으로
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // TextField 흔들기 애니메이션
    func shakeTextField(textField: UITextField){
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
}
