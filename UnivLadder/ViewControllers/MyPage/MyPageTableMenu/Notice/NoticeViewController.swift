//
//  AnnouncementViewController.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/02/12.
//

import UIKit

//공지사항 화면
class NoticeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var NoticeTableView: UITableView!
    
    var isOpen = [false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "공지사항"
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeCell")!
            return cell
        }else {
            //클릭시 펼쳐질 셀
            let cell = tableView.dequeueReusableCell(withIdentifier: "NoticeContentTableViewCell")!
            return cell
        }
        
    }
    
    //section 수
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //cell 수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isOpen[section] == true {
            return 1 + 1
        }else{
            return 1
        }
    }
    
    //cell 크기
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100
        }else {
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? NoticeTableViewCell else {return}
        guard let index = tableView.indexPath(for: cell) else { return }
        
        if index.row == indexPath.row {
            if index.row == 0 {
                if isOpen[indexPath.section] == true {
                    isOpen[indexPath.section] = false
                    let section = IndexSet.init(integer: indexPath.section)
                    tableView.reloadSections(section, with: .fade)
                    
                }else {
                    isOpen[indexPath.section] = true
                    
                    let section = IndexSet.init(integer: indexPath.section)
                    tableView.reloadSections(section, with: .fade)
                }
            }
        }
    }
}
