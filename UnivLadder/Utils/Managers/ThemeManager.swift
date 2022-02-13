//
//  ThemeManager.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/12/06.
//

import Foundation
import UIKit

struct Theme {
    static var mainColor = UIColor(hex: "#6D5AE6") // 보라
    static var inactiveColor = UIColor(hex: "#999999") // 버튼 진한 회색
    
    static var backgroundColor = UIColor.systemBackground
    
    // red
    static var red500 = UIColor(hex: "#FB3030")
    
    // text
    static var labelColor = UIColor.label
    static var whiteColor = UIColor.white
    static var text100 = UIColor(hex: "#DFDEE4")
    static var text200 = UIColor(hex: "#C6C5CD")
    static var text300 = UIColor(hex: "#ABAAB1")
    static var text400 = UIColor(hex: "#89888E")
    static var text500 = UIColor(hex: "#5E5D65")
    static var text600 = UIColor(hex: "#454354")
    static var text700 = UIColor(hex: "#302E43")
    static var text800 = UIColor(hex: "#252339")
    static var text900 = UIColor(hex: "#191632")
    static var text1000 = UIColor(hex: "#ABAFB3")
    
    // light
    static var light300 = UIColor(hex: "#F8F8F8")
    static var light500 = UIColor(hex: "#F4F4F4")
}

extension Theme {
    static var numberFont: UIFont {
        return UIFont(name: "Helvetica", size: 13)!
    }
    static var esamanru11Light: UIFont {
        return UIFont(name: "esamanruOTFLight", size: 11)!
    }
    static var esamanru13Light: UIFont {
        return UIFont(name: "esamanruOTFLight", size: 13)!
    }
    static var esamanru14Light: UIFont {
        return UIFont(name: "esamanruOTFLight", size: 14)!
    }
    static var esamanru16Medium: UIFont {
        return UIFont(name: "esamanruOTFMedium", size: 16)!
    }
    static var gmarketSans12Medium: UIFont {
        return UIFont(name: "GmarketSansMedium", size: 12)!
    }
}


/*
 Gmarket Sans
 ==> GmarketSansMedium
 ==> GmarketSansLight
 ==> GmarketSansBold
 
 esamanru OTF
 ==> esamanruOTFLight
 ==> esamanruOTFMedium
 ==> esamanruOTFBold
 */
