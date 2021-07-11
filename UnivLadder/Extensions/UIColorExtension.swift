//
//  UIColorExtension.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/07/11.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    convenience init(red: Int, green: Int, blue: Int, alpha: CGFloat) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    convenience init(hex : String, alpha : CGFloat) {
        var hexStr = hex
        hexStr = hexStr.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hexStr as String)
        var color: UInt64 = 0
        if scanner.scanHexInt64(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16)
            let g = CGFloat((color & 0x00FF00) >> 8)
            let b = CGFloat(color & 0x0000FF)
            
            self.init(red:Int(r), green:Int(g), blue:Int(b), alpha: alpha)
        } else {
            // Invalid hex string
            self.init(red: 0, green: 0, blue: 0)
        }
    }
    
    convenience init(hex : String) {
        var hexStr = hex
        // let alpha:CGFloat = 1.0
        hexStr = hexStr.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: hexStr as String)
        var color: UInt64 = 0
        if scanner.scanHexInt64(&color) {
            let r = CGFloat((color & 0xFF0000) >> 16)
            let g = CGFloat((color & 0x00FF00) >> 8)
            let b = CGFloat(color & 0x0000FF)
            
            self.init(red:Int(r), green:Int(g), blue:Int(b))
        } else {
            // Invalid hex string
            self.init(red: 0, green: 0, blue: 0)
        }
    }
    
    
}
