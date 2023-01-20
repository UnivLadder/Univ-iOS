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
    var cellTitle = ["알림", "공지사항", "[앱 이름]안내", "앱 캐시 정리하기"]
    var cellIcon = ["bell", "mic", "questionmark.circle", "trash"]
    
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
    
    func myProfileViewSetting() {
        self.myPageName.text = "안이연"
        self.myPageEmail.text = "test1234@gmail.com"
        self.userStatusToggleBtn.setTitleColor(UIColor.black, for: .normal)
        self.userStatusToggleBtn.layer.borderWidth = 1
        self.userStatusToggleBtn.layer.borderColor = UIColor.black.cgColor
        self.userStatusToggleBtn.layer.cornerRadius = 5
        self.userStatusToggleBtn.translatesAutoresizingMaskIntoConstraints = false
      
        if userStatusBool{
            // 유저 상태가 true 면 멘토 등록
            self.userStatusToggleBtn.setTitle("멘티 전환", for: .normal)
            
            self.mentoView.isHidden = false
            self.userStatusViewSetting()
        }else{
            // 유저 상태가 false 면 멘토 등록
            self.userStatusToggleBtn.setTitle("멘토 등록", for: .normal)
            self.mentoView.isHidden = true
        }

    }
    func userStatusViewSetting() {
        self.profileModifyBtn.layer.cornerRadius = 10
        self.mentoScoreLabel.text = "4.5"
        self.reviewLabel.text = "121"
        self.employeeLabel.text = "3"
    }
    
    @IBAction func userStatusChangeBtn(_ sender: Any) {
            //멘토인 경우
        if userStatusBool{
            userStatusBool = false
            myProfileViewSetting()
        }else{
            //멘티인 경우
            userStatusBool = true
            myProfileViewSetting()
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "RegisterMento")
            self.navigationController?.pushViewController(pushVC!, animated: true)
        }
    }
    
    @IBAction func mentoProfileModifyBtn(_ sender: Any) {
        let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "ProfileModifyViewController")
        self.navigationController?.pushViewController(pushVC!, animated: true)
    }
}


extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
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
}
