//
//  UIViewController+Extension.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2022/02/13.
//

import UIKit

extension UIViewController {
    static func changeRootViewControllerToHome() {
        let vc = MainTabBarViewController.instantiate()
        DispatchQueue.main.async {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                return
            }
            windowScene.windows.first?.rootViewController = vc
            windowScene.windows.first?.makeKeyAndVisible()
        }
    }
}
