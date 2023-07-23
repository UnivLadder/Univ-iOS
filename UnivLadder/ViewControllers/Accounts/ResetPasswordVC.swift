//
//  ResetPasswordVC.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/06/24.
//

import Foundation
import UIKit

class ResetPasswordVC: UIViewController {
    var userModel = UserModel() // 인스턴스 생성
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitlelabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailAuthBtn: UIButton!
    
    @IBOutlet weak var emailAuthNumCheckBtn: UIButton!
    @IBOutlet weak var emailAuthErrorLabel: UILabel!
    @IBOutlet weak var authView: UIView!
    @IBOutlet weak var tokenTextField: UITextField!
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordTextField2: UITextField!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    @IBOutlet weak var resetBtn: UIButton!{
        didSet{
            resetBtn.layer.cornerRadius = 10
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.settingUI()
    }
    
    func settingUI() {
        titleLabel.text = "비밀번호를 재설정해요!"
        subTitlelabel.lineBreakMode = .byWordWrapping
        subTitlelabel.numberOfLines = 0
        subTitlelabel.text = "비밀번호 재설정을 위해 입력한 이메일로 인증번호가 전송됩니다. \n가입한 이메일 주소를 입력해 주세요!"
        emailAuthErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
    }
    
    @IBAction func sendTokenToEmailAction(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty else { return }
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
            APIService.shared.reportLostPassword(param: params, completion: {_ in
                let alert = UIAlertController(title:"이메일 인증번호 전송 완료",
                                              message: "메일로 받은 인증번호를 입력해주세요.",
                                              preferredStyle: UIAlertController.Style.alert)
                let buttonLabel = UIAlertAction(title: "확인", style: .default, handler: nil)
                alert.addAction(buttonLabel)
                self.present(alert,animated: true,completion: nil)
            })
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
    
    
    @IBAction func tokenConfirmAction(_ sender: Any) {
        var alert = UIAlertController()
        guard let email = emailTextField.text, !email.isEmpty else {
            //빈값 에러
            return }
        guard let verifyToken = tokenTextField.text, !verifyToken.isEmpty else { return }
        let params = ["email" : email,
                      "verifyToken" : verifyToken]
        
        APIService.shared.resetPassword(param: params, completion: { [self] response in
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
                //                User.email = registerEmailTxt.text!
                //                UserDefaults.standard.setValue(true, forKey: "emailAuth")
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
        })
    }
    
    @IBAction func resetPasswordAction(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let verifyToken = tokenTextField.text else { return }
        guard let password = newPasswordTextField.text else { return }
        guard let password2 = newPasswordTextField2.text, !password.isEmpty else { return }
        
        let params = ["email" : email,
                      "verifyToken" : verifyToken,
                      "password" : password]
        
        APIService.shared.resetPasswordConfirm(param: params, completion: {_ in
            // 유저 비밀번호 업데이트 성공
            let alert = UIAlertController(title: "💙 비밀번호 변경 성공 💙", message: "로그인 하세요.", preferredStyle: .alert)
            let buttonLabel = UIAlertAction(title: "확인", style: .default, handler: nil)
            alert.addAction(buttonLabel)
            self.present(alert, animated: true,completion: nil)
            self.dismiss(animated: true, completion: nil)
        })
    }
}
