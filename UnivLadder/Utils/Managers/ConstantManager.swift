//
//  ConstantManager.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/08/28.
//

import UIKit

//상수 관리
struct Constant {
    // 뷰 전체 폭 길이
    let screenWidth = UIScreen.main.bounds.size.width
        
    // 뷰 전체 높이 길이
    let screenHeight = UIScreen.main.bounds.size.height

    //mainView
    //메뉴별 간격
    static var menuIntervalHeight = UIDevice.current.isiPhoneSE2 ? 20.0 : 40.0
    //메뉴별 컨텐츠와의 간격
    static var menuContentIntervalHeight = UIDevice.current.isiPhoneSE2 ? 15.0 : 20.0
    static var menuContentIntervalHeightMAX = 25.0
    //메뉴 폰트 사이즈
    //xs test
    static var menuFontSizeXS = UIDevice.current.isiPhoneSE2 ? 15.0 : 20.0
    //14 Pro Max test
    static var menuFontSizeMAX = 28.0
    
    //프로필 이미지 사이즈
    static var profileImgSize = 80.0
    static var profileImgSizeMAX = 85.0
    
    //카테고리 이미지 사이즈
    static var categoryImgSize = 110.0
    static var cornerRadius: CGFloat = 10
}

struct Storyboard {
    struct Name {
        static let SubjectModifyViewController = "SubjectModifyViewController"
    }
    
    struct Msg {
        static let registerMentoConfirmMsg = "멘토로 등록되었습니다."
        static let modifyMentoConfirmMsg = "멘토 정보가 수정되었습니다."
    }
}
