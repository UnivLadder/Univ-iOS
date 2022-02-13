//
//  MainTabBarVC.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/05/09.
//

import UIKit

enum TabBarItem: Int {
    case MentoList
    case Chat
    case MyPage
    
    var description: String {
        switch self {
        case .MentoList:
            return "홈"
        case .Chat:
            return "채팅"
        case .MyPage:
            return "마이페이지"
        }
    }
}

class MainTabBarViewController: UITabBarController, StoryboardInitializable {

    static var storyboardID: String = "MainTabBarViewController"
    static var storyboardName: String = "Main"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tabBar.items?[TabBarItem.MentoList.rawValue].title = TabBarItem.MentoList.description
        tabBar.items?[TabBarItem.MentoList.rawValue].image = UIImage(named: "home")
        
        tabBar.items?[TabBarItem.Chat.rawValue].title = TabBarItem.Chat.description
        tabBar.items?[TabBarItem.MyPage.rawValue].title = TabBarItem.MyPage.description
        
    }

}
