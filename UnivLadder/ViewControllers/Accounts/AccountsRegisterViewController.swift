//
//  AccountsRegisterViewController.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2021/12/06.
//

import UIKit
import AuthenticationServices

class AccountsRegisterViewController: UIViewController {
    
    
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    
    
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
        maleBtn.layer.borderColor = UIColor.black.cgColor
        maleBtn.layer.cornerRadius = 10
        
        femaleBtn.backgroundColor = UIColor.white
        femaleBtn.layer.borderWidth = 1
        femaleBtn.layer.borderColor = UIColor.black.cgColor
        femaleBtn.layer.cornerRadius = 10
    }
    
}
