//
//  AccountModifyViewController.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/03/06.
//

import UIKit

class AccountModifyViewController: UIViewController {
    @IBOutlet weak var modifyTableView: UITableView!
    
    var modifyList = ["본인 인증", "수업 인증 지역", "이동 가능 거리", "연락 가능 시간 등록" ,"수업 가능 일자 등록", "수업 가격 정보 등록", "사업자등록증 등록", "자격증 등록", "졸업증명서/재학증명서 등록", "제공 서비스 분야 등록", "서비스 상세설명 등록"]
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    

}


extension AccountModifyViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modifyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = modifyTableView.dequeueReusableCell(withIdentifier: "ModifyCell", for: indexPath) as! AccountModifyTableViewCell
        cell.backgroundColor = .white
        cell.titleLabel.text = modifyList[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        modifyTableView.deselectRow(at: indexPath, animated: true)

        switch indexPath.row {
        // 서비스 과목 선택 수정 화면
        case 9:
            self.performSegue(withIdentifier: "toSubjectModify", sender: nil)

        default:

            return

        }

    }
}
