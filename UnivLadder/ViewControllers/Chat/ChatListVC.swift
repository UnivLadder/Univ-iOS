//
//  ChatListVC.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/05/09.
//

import UIKit

class ChatListVC: UIViewController {

    @IBOutlet weak var chatRoomListTableView: UITableView!
    
    let chatRooms = ["클라라", "클라리", "클러리"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        chatRoomListTableView.delegate = self
        chatRoomListTableView.dataSource = self
        
        setUI()
    }
    
    
    private func setUI() {
        self.navigationController?.navigationBar.transparentNavigationBar()
        
        self.navigationItem.title = ""
        
        self.chatRoomListTableView.separatorStyle = .none
    }

}

extension ChatListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRooms.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell") as! ChatRoomListCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChatRoomVC.instance()
        vc.navigationItem.title = chatRooms[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
