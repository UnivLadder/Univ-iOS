//
//  AccountModifyViewController.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/03/06.
//

import UIKit

// 멘토 프로필 수정 화면
class ProfileModifyViewController: UIViewController {
    
    @IBOutlet weak var modifyTableView: UITableView!
    var modifyList = ["제공 서비스 분야 등록", "서비스 상세설명 등록"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


extension ProfileModifyViewController: UITableViewDelegate, UITableViewDataSource{
    
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
        case 0:
            self.performSegue(withIdentifier: "toSubjectModify", sender: nil)
        // 서비스 상세설명 등록
        case 1:
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "MentoInfo") as? MentoDetailModifyViewController
            self.navigationController?.pushViewController(pushVC!, animated: true)
        default:
            return
        }
    }
}
