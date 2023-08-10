//
//  MyPageVC.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/10/10.
//

import UIKit

class MyPageViewController: UIViewController {
    @IBOutlet weak var userStatusToggleBtn: UIButton!

    var mentoRegistStatus : Bool = false
    
    // core data에서 user 정보 가져옴
    let userInfo = CoreDataManager.shared.getUserInfo()
    var myMentoAccount: RecommendMentor?
    
    @IBOutlet weak var myPageImg: UIImageView!
    @IBOutlet weak var myPageName: UILabel!
    @IBOutlet weak var myPageEmail: UILabel!
    @IBOutlet weak var myPageNameNim: UILabel!
    
    //mento view info
    @IBOutlet weak var mentoView: UIView!
    @IBOutlet weak var profileModifyBtn: UIButton!
    
    @IBOutlet weak var mentoScoreLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    @IBOutlet weak var employeeLabel: UILabel!
    
    //마이페이지 목록
    @IBOutlet weak var MyPageTableView: UITableView!
    var cellTitle = ["알림", "공지사항", "[Real Tutor] 안내", "로그아웃"]
    var cellIcon = ["bell", "mic", "questionmark.circle", "rectangle.portrait.and.arrow.right"]
    
    @IBAction func MoveToRegister(_ sender: Any) {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "MentoRegister"){
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.transparentNavigationBar()
        self.navigationItem.title = ""
        self.myProfileViewSetting()
        
    }
    
    // 프로필 뷰
    func myProfileViewSetting() {
        // 멘토인지 아는지 확인(현재 user 정보의 mentor 값으로 확인)
        // 멘토인 경우 > 멘토 정보 가져오기
        if userInfo[0].mentor {
            // 내가 멘토 등록된 경우
            self.mentoRegistStatus = true
            if let accessToken = UserDefaults.standard.string(forKey: "accessToken") {
                APIService.shared.getMyMentoAccount(accessToken: accessToken, completion: { [self] response in
                    myMentoAccount = response
                    
                    if let score = myMentoAccount?.averageReviewScore{
                        self.mentoScoreLabel.text = "\(score)"
                    }else{
                        self.mentoScoreLabel.text = "\(0)"
                    }
                    
                    if let score = myMentoAccount?.reviewCount{
                        self.reviewLabel.text = "\(score)"
                    }else{
                        self.reviewLabel.text = "\(0)"
                    }
                    
                    //채팅방 개수
                    let score = UserDefaults.standard.integer(forKey: "ChatCount")
                    self.employeeLabel.text = "\(score)"
                    
                 
                    //멘토 아이디 전역 변수 저장
                    UserDefaults.standard.setValue(myMentoAccount?.mentoId, forKey: "MyMentoId")
                })
            }
        }
        
        if userInfo.count > 0{
            self.myPageName.text = userInfo[0].name
            self.myPageEmail.text = userInfo[0].email
        }else{
            self.myPageName.text = "홍길동"
            self.myPageEmail.text = "lxxyeon@gmail.com"
        }
        
        // 없는 경우 기본 이미지
        self.myPageImg.image = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(#colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1), renderingMode: .alwaysOriginal)
        
//        if userInfo[0].thumbnail != nil {
//            self.myPageImg.image = UIImage(named: userInfo[0].thumbnail)
//        }
//
        self.userStatusToggleBtn.setTitleColor(UIColor.black, for: .normal)
        self.userStatusToggleBtn.layer.borderWidth = 1
        self.userStatusToggleBtn.layer.borderColor = UIColor.black.cgColor
        self.userStatusToggleBtn.layer.cornerRadius = 5
      
        //멘토 등록 상태인지 확인
        if mentoRegistStatus{
            // 멘토 등록된 경우
            self.userStatusToggleBtn.isHidden = true
            self.mentoView.isHidden = false
            self.userStatusViewSetting()
        }else{
            // 멘토 등록 안된 경우
            self.userStatusToggleBtn.isHidden = false
            self.mentoView.isHidden = true
            self.userStatusToggleBtn.setTitle("멘토 등록", for: .normal)
        }
    }
    
    func userStatusViewSetting() {
        self.profileModifyBtn.layer.cornerRadius = 10
    }

    /// 멘토 등록
    /// - Parameter sender: 상태 변경
    @IBAction func userStatusChangeBtn(_ sender: Any) {
        //멘토인 경우
        if mentoRegistStatus{
            mentoRegistStatus = true
            myProfileViewSetting()
        }else{
            // 멘티인 경우 - 멘토로 등록 API 수행
            mentoRegistStatus = false
            myProfileViewSetting()
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "MentoRegister")
            self.navigationController?.pushViewController(pushVC!, animated: true)
        }
    }
    
    
    /// 계정 정보 수정
    /// - Parameter sender: 상태 변경
    
    
    
    
    
    
    /// 멘토 계정 정보 수정
    /// - Parameter sender:상태 변경
    @IBAction func mentoProfileModifyBtn(_ sender: Any) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileModifyViewController")
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
}


extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageCell") as! MyPageCell
        cell.selectionStyle = .none
        cell.titleLabel.text = cellTitle[indexPath.item]
        cell.iconImg.image = UIImage(systemName: cellIcon[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    // 마이페이지 테이블 뷰
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MyPageTableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.row {
        // 알림 -> 환경 설정 알림 이동
        case 0:
            if let url = URL(string: UIApplication.openSettingsURLString) {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        // 공지사항
        case 1:
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "Announcement"){
                self.navigationController?.pushViewController(controller, animated: true)
            }
        // [앱 이름] 안내
        case 2:
            if let controller = self.storyboard?.instantiateViewController(withIdentifier: "AppInfo"){
                self.navigationController?.pushViewController(controller, animated: true)
            }
        // 로그 아웃
        default:
            var alert = UIAlertController()
            alert = UIAlertController(title:"로그아웃 하시겠습니까?",
                                      message: "",
                                      preferredStyle: UIAlertController.Style.alert)
            let buttonLabel = UIAlertAction(title: "확인", style: .default, handler: { action in
                // 자동로그인 해제
                UserDefaults.standard.setValue(false, forKey: "isAutoLogin")
                self.signOut()
            })
            alert.addAction(buttonLabel)
            self.present(alert,animated: true,completion: nil)
            return
        }
    }
    
    func signOut() {
        UIViewController.changeRootViewControllerToLogin()
        CoreDataManager.shared.deleteAllUsers()
    }
}
