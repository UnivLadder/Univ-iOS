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
    
    @IBOutlet weak var registerName: UITextField!
    @IBOutlet weak var registerEmail: UITextField!
    @IBOutlet weak var registerPassword: UITextField!
    @IBOutlet weak var registerPassword2: UITextField!
    
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var nextBtn: UIButton!
    
    @IBOutlet weak var backBtn: UIButton!
    
    //회원가입
    //1. 자체 회원가입
    //2. 소셜 회원가입
    //소셜 화면 > 소셜화면에서 동의 받음 > 우리 화면 본인인증
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewComponents()
        // Do any additional setup after loading the view.
    }
    
    func viewComponents() {
        maleBtn.backgroundColor = UIColor.white
        maleBtn.layer.borderWidth = 1
        maleBtn.layer.borderColor = Colors.main.color.cgColor
        maleBtn.layer.cornerRadius = 10
        
        femaleBtn.backgroundColor = UIColor.white
        femaleBtn.layer.borderWidth = 1
        femaleBtn.layer.borderColor = Colors.main.color.cgColor
        femaleBtn.layer.cornerRadius = 10
        
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
    }
    
    //입력받은 값들 확인
    //회원가입 완료
    // 다음 버튼 클릭
    @IBAction func registerCompleteAction(_ sender: Any) {
        
        // 옵셔널 바인딩 & 예외 처리 : Textfield가 빈문자열이 아니고, nil이 아닐 때
        guard let name = registerName.text, !name.isEmpty else { return }
        guard let email = registerEmail.text, !email.isEmpty else { return }
        guard let password = registerPassword.text, !password.isEmpty else { return }
        guard let password2 = registerPassword2.text, !password.isEmpty else { return }
        
        // 이메일 형식 오류
        if userModel.isValidEmail(id: email){
            //nil 처리 추가
            //emailErrorLabel.text = " "
            if let removable = self.view.viewWithTag(100) {
                removable.removeFromSuperview()
            }
        }
        else {
            shakeTextField(textField: registerEmail)
            emailErrorLabel.text = "잘못된 형식의 이메일입니다."
            emailErrorLabel.textColor = UIColor.red
            emailErrorLabel.tag = 100
            emailErrorLabel.isHidden = false
        }
        
        // 비밀번호 형식 오류
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
            // 비밀번호 두개 비교
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
        
        let registeParam: Parameters = [
            "email" : "test4@gmail.com",
            "password" : "PASSWORD",
            "name" : "이연",
            "thumbnail" : "THUMBNAIL",
            "gender" : "WOMAN"
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
