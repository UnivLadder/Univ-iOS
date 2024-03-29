//
//  SceneDelegate.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/04/01.
//

import UIKit
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.handleOpenUrl(url: url)
            }
        }
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        //isAutoLogin
        //자동로그인이 설정되어 있는 경우 홈화면으로 시작
        if UserDefaults.standard.bool(forKey:"isAutoLogin") == true {
            let vc = MainTabBarViewController.instantiate()
            DispatchQueue.main.async {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
                    return
                }
                windowScene.windows.first?.rootViewController = vc
                windowScene.windows.first?.makeKeyAndVisible()
            }
        }

        //시작 화면 바꿔가면서 테스트
//        guard let _ = (scene as? UIWindowScene) else { return }
//        let storyboard = UIStoryboard(name: "MyPage", bundle: nil)
//        guard let loginVC = storyboard.instantiateViewController(withIdentifier: "MyPage") as? MentoSearchViewController else { return }
//        window?.rootViewController = loginVC
        
        //멘토 검색화면
//        guard let _ = (scene as? UIWindowScene) else { return }
//        let storyboard = UIStoryboard(name: "MentoCategory", bundle: nil)
//        guard let loginVC = storyboard.instantiateViewController(withIdentifier: "MentoCategory") as? MentoSearchViewController else { return }
//        window?.rootViewController = loginVC
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

