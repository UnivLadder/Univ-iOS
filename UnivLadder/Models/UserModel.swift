//
//  UserModel.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2021/12/20.
//

import UIKit

final class UserModel {
    struct User {
        var username: String
        var password: String
    }
    
    var users: [User] = [
        User(username: "abc1234@naver.com", password: "qwerty1234"),
        User(username: "dazzlynnnn@gmail.com", password: "asdfasdf5678")
    ]
    
    // 아이디 형식 검사
    func isValidEmail(id: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: id)
    }
    
    // 비밀번호 형식 검사
    func isValidPassword(pwd: String) -> Bool {
        let passwordRegEx = "^[a-zA-Z0-9]{8,}$"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: pwd)
    }
} // end of UserModel
