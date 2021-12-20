//
//  AccountsRegisterViewController.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2021/12/06.
//

import UIKit

class AccountsRegisterViewController: UIViewController {

    
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    
    
    //회원가입
    //1. 자체 회원가입
    //2. 소셜 회원가입
    //소셜 화면 > 소셜화면에서 동의 받음 > 우리 화면 본인인증
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func viewComponents() {
        maleBtn.layer.borderWidth = 2

    }

}
