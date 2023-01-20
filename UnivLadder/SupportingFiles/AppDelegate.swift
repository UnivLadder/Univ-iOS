import UIKit
import CoreData
import Firebase
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        KakaoSDK.initSDK(appKey: "48b6d54e30616f77f66d47cc2f1a7fce")
        // 과목 리스트 초기화
        //과목 리스트
        //        APIService.shared.getSubjects()
        
        //앱파일 경로 확인
        print("App bundle path : \(Bundle.main)")
        
        //FCM 설정
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter
            .current()
            .requestAuthorization(
                options: authOptions,completionHandler: { (_, _) in }
            )
        application.registerForRemoteNotifications()
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        var handled: Bool
        
        handled = GIDSignIn.sharedInstance.handle(url)
        if handled {
            return true
        }
        
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }
        
        // Handle other custom URL types.
        
        // If not handled by this app, return false.
        return false
    }
    // MARK: UISceneSession Lifecycle
    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        sleep(100)
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // Core Data 가 앱 꺼지기 전에 저장
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext()
    }
    
    
    // MARK: - Core Data stack
    //persistentContainer : Coredata 내용을 수정, 관리해주는 프로퍼티
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        // name: Core Data 만든 파일명 지정
        // 멘토 DB
        // name: Core Data 만든 파일명 지정
        let container = NSPersistentContainer(name: "UserModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error, \((error as NSError).userInfo)")
            }
        })
        return container
        
        //        let container = NSPersistentContainer(name: "UnivLadder")
        //        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
        //            if let error = error as NSError? {
        //
        //                fatalError("Unresolved error \(error), \(error.userInfo)")
        //            }
        //        })
        //        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}

extension AppDelegate : MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        // 파이버에이스 토큰 보내기 api 실행
        // http://52.78.43.121/docs/index.html#_x_%EA%B3%84%EC%A0%95_fcm_%ED%86%A0%ED%81%B0_%EC%88%98%EC%A0%95
        if let fcmToken = fcmToken {
            print("파이어베이스 토큰: \(fcmToken)")
            APIService.shared.putFCMToken(with: fcmToken)
        }
        

    }
    
}
