//
//  MainTabBarVC.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/05/09.
//

import UIKit

enum TabBarItem: Int {
    case MentoList
    case Chatting
    case MyPage
    
    var description: String {
        switch self {
        case .MentoList:
            return "홈"
        case .Chatting:
            return "채팅"
        case .MyPage:
            return "마이페이지"
        }
    }
}

class MainTabBarViewController: UITabBarController, StoryboardInitializable {

    static var storyboardID: String = "MainPage"
    static var storyboardName: String = "Main"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        
    }

}
