//
//  AccountsMainViewController.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2021/12/06.
//

import UIKit
import AuthenticationServices

class AccountsMainViewController: UIViewController, ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {

    
    
    var userModel = UserModel() // 인스턴스 생성
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var emailErrorLabel: UILabel!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var autoLoginCheckmark: UIButton!
    
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var registerBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageView = UIImageView();
        let image = UIImage(named: "emailIcon.png");
        imageView.image = image;
        emailTextField.leftView = imageView;
        
        emailErrorLabel.isHidden = true
        passwordErrorLabel.isHidden = true
    }
    //로그인 구현
    //1. 자체 로그인 2.구글 소셜 로그인 3.애플 소셜 로그인
    
    //1. 자체 로그인
    //    "username" : "sign-in@gmail.com",
    //    "password" : "password"
    //텍스트에 이모티콘 넣기
    @IBAction func loginCheck(_ sender: Any) {
        // 옵셔널 바인딩 & 예외 처리 : Textfield가 빈문자열이 아니고, nil이 아닐 때
        guard let email = emailTextField.text, !email.isEmpty else { return }
        guard let password = passwordTextField.text, !password.isEmpty else { return }
        
        // 이메일 형식 오류
        if userModel.isValidEmail(id: email){
            //nil 처리 추가
            //            emailErrorLabel.text = " "
            if let removable = self.view.viewWithTag(100) {
                removable.removeFromSuperview()
            }
        }
        else {
            shakeTextField(textField: emailTextField)
            emailErrorLabel.text = "잘못된 형식의 이메일입니다."
            emailErrorLabel.textColor = UIColor.red
            emailErrorLabel.tag = 100
            emailErrorLabel.isHidden = false        }
        
        // 비밀번호 형식 오류
        if userModel.isValidPassword(pwd: password){
            if let removable = self.view.viewWithTag(101) {
                removable.removeFromSuperview()
            }
        }
        else{
            shakeTextField(textField: passwordTextField)
            passwordErrorLabel.text = "비밀번호를 다시 입력해주세요."
            passwordErrorLabel.textColor = UIColor.red
            passwordErrorLabel.tag = 101
            passwordErrorLabel.isHidden = false
            
        }
        
        if userModel.isValidEmail(id: email) && userModel.isValidPassword(pwd: password) {
            let loginSuccess: Bool = loginCheck(id: email, pwd: password)
            if loginSuccess {
                print("로그인 성공")
                if let removable = self.view.viewWithTag(102) {
                    removable.removeFromSuperview()
                }
                self.performSegue(withIdentifier: "showMain", sender: self)
            }
            else {
                print("로그인 실패")
                shakeTextField(textField: emailTextField)
                shakeTextField(textField: passwordTextField)
                let loginFailLabel = UILabel(frame: CGRect(x: 68, y: 510, width: 279, height: 45))
                loginFailLabel.text = "비밀번호를 다시 입력해주세요."
                loginFailLabel.textColor = UIColor.red
                loginFailLabel.tag = 102
                
                self.view.addSubview(loginFailLabel)
            }
        }
    }
    
    // 로그인 method
    func loginCheck(id: String, pwd: String) -> Bool {
        for user in userModel.users {
            if user.username == id && user.password == pwd {
                return true // 로그인 성공
            }
        }
        return false
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
    
    //구글 소셜 로그인
    @IBAction func googleLogin(_ sender: Any) {
    }
    
    //애플 소셜 로그인
    @IBAction func appleLogin(_ sender: Any) {
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
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
                
            print("User ID : \(userIdentifier)")
            print("User Email : \(email ?? "")")
            print("User Name : \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
     
        default:
            break
        }
    }
        
    // Apple ID 연동 실패 시
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
    @IBAction func moveToRegist(_ sender: Any) {
        performSegue(withIdentifier: "toRegist", sender: nil)
    }
}

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
            // Note: In order for your image to use the tint color, you have to select the image in the Assets.xcassets and change the "Render As" property to "Template Image".
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
