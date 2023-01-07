//
//  MyPageVC.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/10/10.
//

import UIKit

class MyPageViewController: UIViewController {
    @IBOutlet weak var MyPageTableView: UITableView!
    
    @IBAction func MoveToRegister(_ sender: Any) {
        if let controller = self.storyboard?.instantiateViewController(withIdentifier: "MentoRegister"){
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.transparentNavigationBar()
        self.navigationItem.title = ""
        // Do any additional setup after loading the view.
    }
}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyPageCell") as! MyPageCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
