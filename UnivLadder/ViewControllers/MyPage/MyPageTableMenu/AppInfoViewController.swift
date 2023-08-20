//
//  AlramViewController.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/02/05.
//

import UIKit

//앱 안내 페이지
class AppInfoViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    var cellTitle = ["개인정보 처리방침", "오픈소스 라이선스", "앱 버전"]
    var appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String

    override func viewDidLoad() {
        self.navigationItem.title = "[앱] 안내"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppInfoTableViewCell")! as! AppInfoTableViewCell
        cell.appInfoLabel.text = cellTitle[indexPath.item]
        
        if indexPath.item == cellTitle.count-1 {
            cell.appVersionLabel.text = appVersion
        }else{
            cell.appVersionLabel.text = ""
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        // 개인정보 처리방침
        case 0:
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "AppInfoPrivate") as? AppInfoPrivateViewController
            self.navigationController?.pushViewController(pushVC!, animated: true)
        //오픈소스 라이브러리
        case 1:
            let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "AppInfoPrivate") as? AppInfoPrivateViewController
            self.navigationController?.pushViewController(pushVC!, animated: true)
            pushVC!.status = 1
        default:
            return
        }
    }
}
