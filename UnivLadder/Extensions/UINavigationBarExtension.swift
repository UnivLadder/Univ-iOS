//
//  UINavigationBarExtension.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/07/11.
//

import UIKit

extension UINavigationBar {
    func transparentNavigationBar() {
        self.setBackgroundImage(UIImage(), for: .default)
        self.shadowImage = UIImage()
        self.isTranslucent = true
    }
}
