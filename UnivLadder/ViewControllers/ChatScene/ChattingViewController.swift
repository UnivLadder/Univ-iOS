//
//  ChattingViewController.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/01/08.
//

import UIKit

class ChattingViewController: UIViewController {

    @IBOutlet weak var chatTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}
extension ChattingViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath) as? ChatRoomListCell else {
            return UITableViewCell()
        }
        return cell
    }
}
