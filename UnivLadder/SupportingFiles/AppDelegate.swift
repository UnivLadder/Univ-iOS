import UIKit
import CoreData
import Firebase
import FirebaseMessaging
import GoogleSignIn
import KakaoSDKAuth
import KakaoSDKCommon
import Alamofire

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // FCM - Firebase 초기화 세팅. (구글 로그인, FCM 사용용)
        FirebaseApp.configure()
        
        UNUserNotificationCenter.current().delegate = self
        
        // 파이어베이스 Meesaging 설정
        Messaging.messaging().delegate = self
        

        // APNs - 원격 알림 등록
        registerForRemoteNotifications()
        
        
        // 메시지 대리자 설정
        Messaging.messaging().delegate = self
        // FCM 다시 사용 설정
        Messaging.messaging().isAutoInitEnabled = true
        
        
        // 등록된 token 확인
        Messaging.messaging().token { token, error in
            if let error = error {
                print("Error fetching FCM registration token: \(error)")
            } else if let token = token {
                print("FCM registration token: \(token)")
            }
        }
        
        //https://babbab2.tistory.com/57
        
        // 카카오톡 소셜 로그인은 위한 appKey 등록
        KakaoSDK.initSDK(appKey: "48b6d54e30616f77f66d47cc2f1a7fce")
        
        // 과목 리스트 초기화
        //과목 리스트
        DispatchQueue.global().async {
            APIService.shared.getSubjects()
        }


        // 추천멘토 초기화
        if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
            APIService.shared.getRecommendMentors(accessToken: accessToken)
        }

        //앱파일 경로 확인
        //        print("App bundle path : \(Bundle.main)")
        //        // User default 값 조회
        //        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
        //          print("\(key) = \(value) \n")
        //        }
        //        print("App Directory path : \(NSHomeDirectory())")
        //
        
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
    
    // Core Data 가 앱 꺼지기 전에 저장
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        self.saveContext()
    }
    
    // MARK: - Push Notification Handling
    // push noti 전송한 경우
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        let gcmMessageIdKey = "gcm.message_id"
        // Print message ID.
        if let messageId = userInfo[gcmMessageIdKey]{
            print("Message ID: \(messageId)")
        }
    }
    
    // device 토큰 등록 성공 시 실행되는 메소드
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // APN 토큰과 등록 토큰 매핑
    }
    
    // device 토큰 등록 실패 시 실행되는 메소드
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    
    private func registerForRemoteNotifications() {
        // 1. 푸시 center (유저에게 권한 요청 용도)
        let center = UNUserNotificationCenter.current()
        // push처리에 대한 delegate - UNUserNotificationCenterDelegate
        center.delegate = self
        
        // UNUserNotificationCenterDelegate를 구현한 메서드를 실행시킴
        UIApplication.shared.registerForRemoteNotifications()
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        center.requestAuthorization(options: options) { (granted, error) in
            guard granted else {
                return
            }
            // UNUserNotificationCenterDelegate를 구현한 메서드를 실행시킴
            DispatchQueue.main.async {
                // 2. APNs에 디바이스 토큰 등록
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    // push noti click한 경우
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //Push message 데이터
        let msgData = response.notification.request.content.userInfo
        msgData["aps"]
        Messaging.messaging().appDidReceiveMessage(msgData)
        //채팅화면으로 오픈하기
        //        Optional({
        //            alert =     {
        //                body = 테스트요;
        //                title = 테스트요;
        //            };
        //            "mutable-content" = 1;
        //        })
    }
    
    // MARK: - Core Data stack
    //persistentContainer : Coredata 내용을 수정, 관리해주는 프로퍼티
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "UserModel")// Core Data 파일 명 지정
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error, \((error as NSError).userInfo)")
            }
        })
        return container
    }()
    
    var container: NSPersistentContainer {
        return persistentContainer
    }
    
    private var mainContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
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
    // 현재 등록 토큰 가져오기.
    // 앱 시작 시 한번 실해
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        
        // 파이버에이스 토큰 보내기 api 실행
        
        if let fcmToken = fcmToken {
            print("파이어베이스 토큰: \(fcmToken)")
            UserDefaults.standard.setValue(fcmToken, forKey: "fcmToken")
        }
    }
}
