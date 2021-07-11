//
//  ChatRoomVC.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/05/09.
//

import UIKit

class ChatRoomVC: UIViewController {
    
    static func instance() -> ChatRoomVC {
        let vc = UIStoryboard.init(name: "Chat", bundle: nil).instantiateViewController(withIdentifier: "ChatRoomVC") as! ChatRoomVC
        return vc
    }

    @IBOutlet weak var chatBubbleTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        chatBubbleTableView.delegate = self
        chatBubbleTableView.dataSource = self
        
        chatBubbleTableView.separatorStyle = .none
    }
    


}

extension ChatRoomVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyBubble", for: indexPath) as! ChatBubbleCell
        cell.selectionStyle = .none
        return cell
    }
    
    
}
