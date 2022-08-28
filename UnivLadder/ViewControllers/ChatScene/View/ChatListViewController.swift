//
//  ChatListViewController.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2021/05/09.
//

import UIKit
import RxSwift
import RxCocoa

final class ChatListViewController: UIViewController {

    @IBOutlet weak var chatRoomListTableView: UITableView! {
        didSet {
            chatRoomListTableView.rowHeight = UITableView.automaticDimension
            chatRoomListTableView.separatorStyle = .none
        }
    }
    
    let viewModel = ChatListViewModel()
    var disposeBag = DisposeBag()

    
    override func viewDidLoad() {
        super.viewDidLoad()
//        chatRoomListTableView.delegate = self
//        chatRoomListTableView.dataSource = self
        setUI()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("뷰 나타마?")
    }
    
    struct TEST: Codable {
        let id: String
        let createdDate: String
        let lastChatMessage: String?

        enum CodingKeys: String, CodingKey {
            case id = "accountId"
//            case accountID = "accountId2"
            case createdDate = "accountId3"
            case lastChatMessage = "accountId4"
        }
    }
}

private extension ChatListViewController {
    func setUI() {
        self.navigationController?.navigationBar.transparentNavigationBar()
        self.navigationItem.title = ""
    }
    
    func bindViewModel() {
        let input = ChatListViewModel.Input(
            viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in })
        
        let output = viewModel.transform(input: input, disposeBag: disposeBag)
        
        output.chatroomList.bind(to: chatRoomListTableView.rx.items(
            cellIdentifier: "ChatRoomCell",
            
            cellType: ChatRoomListCell.self)) { (index: Int, element: ChatRoom, cell: ChatRoomListCell) in
//            cellType: ChatRoomListCell.self)) { (index: Int, element: TEST, cell: ChatRoomListCell) in
//                cell.nameLabel.text = "이름"
//                cell.lastMessageLabel.text = "안녕"
//                cell.timeLabel.text = "9/12"
                
                cell.nameLabel.text = "\(element.id)"
                cell.lastMessageLabel.text = element.lastChatMessage ?? ""
                cell.timeLabel.text = element.createdDate

        }.disposed(by: disposeBag)
        
    }
}



