//
//  UIDevice+Extension.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/08/26.
//

import Foundation
import UIKit
// 뷰 전체 폭 길이
let screenWidth = UIScreen.main.bounds.size.width
// 뷰 전체 높이 길이
let screenHeight = UIScreen.main.bounds.size.height

extension UIDevice{

    public var isiPhoneXS: Bool{
        if screenHeight == 812 {
            return true
        }else{
            return false
        }
    }
    
    public var isiPhoneSE: Bool{
        if screenHeight == 568 {
            return true
        }
        else {
            return false
        }
    }

    public var isiPhoneSE2: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone && (UIScreen.main.bounds.size.height == 568 || UIScreen.main.bounds.size.width == 320) {
            return true
        }
        return false
    }

}
