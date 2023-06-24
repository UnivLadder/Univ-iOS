//
//  MyPageVC.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/10/10.
//

import UIKit

class MyPageViewController: UIViewController {
    @IBOutlet weak var userStatusToggleBtn: UIButton!
    //userStatusBool > true > 멘토인 경우
    //userStatusBool > false > 멘티인 경우
    var userStatusBool : Bool = true
    
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
    var cellTitle = ["알림", "공지사항", "[Real Tutor] 안내"]
    var cellIcon = ["bell", "mic", "questionmark.circle"]
    
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
        // core data에서 user 정보 가져옴
        let userInfo = CoreDataManager.shared.getUserInfo()
        
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
      
        if userStatusBool{
            // 유저 상태가 true 면 멘티로 등록
            self.userStatusToggleBtn.setTitle("멘티로 전환", for: .normal)
            self.mentoView.isHidden = false
            self.userStatusViewSetting()
        }else{
            // 유저 상태가 false 면 멘토로 등록
            self.userStatusToggleBtn.setTitle("멘토로 전환", for: .normal)
            self.mentoView.isHidden = true
        }
    }
    
    func userStatusViewSetting() {
        self.profileModifyBtn.layer.cornerRadius = 10
        self.mentoScoreLabel.text = "4.5"
        self.reviewLabel.text = "121"
        self.employeeLabel.text = "3"
    }

    /// 멘토 등록
    /// - Parameter sender: 상태 변경
    @IBAction func userStatusChangeBtn(_ sender: Any) {
            //멘토인 경우
        if userStatusBool{
            userStatusBool = false
            myProfileViewSetting()
        }else{
            // 멘티인 경우 - 멘토로 등록 API 수행
            userStatusBool = true
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
        // 앱 캐시 정리하기
        default:
            return
        }
    }
}
