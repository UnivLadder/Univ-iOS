//
//  MyPageVC.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/10/10.
//

import UIKit

class MyPageVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}


extension MyPageVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyProfileCell", for: indexPath)
            return cell

        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyProfileCell", for: indexPath)
            return cell
        }
        
    }
    
}
