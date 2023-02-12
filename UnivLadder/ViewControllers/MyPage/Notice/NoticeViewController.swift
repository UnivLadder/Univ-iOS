//
//  AnnouncementViewController.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/02/12.
//

import UIKit

class NoticeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var NoticeTableView: UITableView!

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
        return 1
//        if items[section].open == true {
//            return 1 + 1
//        }else{
//            return 1
//        }
    }

    //cell 크기
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 110
        }else {
            return 250
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? NoticeTableViewCell else {return}
        guard let index = tableView.indexPath(for: cell) else { return }
        
        if index.row == indexPath.row {
                    if index.row == 0 {
                        if items[indexPath.section].open == true {
                            items[indexPath.section].open = false
                            cell.arrowImg.image = UIImage(named: "uparrow")
                            let section = IndexSet.init(integer: indexPath.section)
                            tableView.reloadSections(section, with: .fade)
                            
                        }else {
                            items[indexPath.section].open = true
                            cell.arrowImg.image = UIImage(named: "downarrow")
                            let section = IndexSet.init(integer: indexPath.section)
                            tableView.reloadSections(section, with: .fade)
                        }
                    }
                }
        
    }
}
