//
//  UIDevice+Extension.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/08/26.
//

import Foundation
import UIKit

extension UIDevice{
    public var isiPhoneSE2: Bool{
        // 뷰 전체 폭 길이
        let screenWidth = UIScreen.main.bounds.size.width
        
        // 뷰 전체 높이 길이
        let screenHeight = UIScreen.main.bounds.size.height
        if screenHeight == 896 {
            print("iPhone 11, 11proMax, iPhone XR")
            return false
        }
        else if screenHeight == 926 {
            print("iPhone 12proMax")
            return false
        }
        else if screenHeight == 844 {
            print("iPhone 12, 12pro")
            return false
        }
        else if screenHeight == 736 {
            print("iPhone 8plus")
            return false
        }
        else if screenHeight == 667 {
            print("iPhone 8")
            return false
        }
        else if screenHeight == 568 {
            print("iPhone SE")
            return true
        }
        else {
            print("iPhone 12 mini, iPhone XS")
            return false
        }
    }

    public var isiPhoneSE: Bool {
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone && (UIScreen.main.bounds.size.height == 568 || UIScreen.main.bounds.size.width == 320) {
            return true
        }
        return false
    }

}
