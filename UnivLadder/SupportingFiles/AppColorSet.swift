//
//  AppColorSet.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/07/18.
//

import Foundation
import UIKit

public enum ColorSet: String {
    case main = "6D5AE6"
    
    func toColor() -> UIColor {
        return UIColor(named: self.rawValue) ?? UIColor.clear
    }
}
