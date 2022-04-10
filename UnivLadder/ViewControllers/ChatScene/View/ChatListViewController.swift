//
//  ChatListViewController.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/05/09.
//

import UIKit

final class ChatListViewController: UIViewController {

    @IBOutlet weak var chatRoomListTableView: UITableView! {
        didSet {
            chatRoomListTableView.rowHeight = UITableView.automaticDimension
        }
    }
    
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

extension ChatListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatRooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell") as! ChatRoomListCell
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChatRoomViewController.instance()
        vc.navigationItem.title = chatRooms[indexPath.row]
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
