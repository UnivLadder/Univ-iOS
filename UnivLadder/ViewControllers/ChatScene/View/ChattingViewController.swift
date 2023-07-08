//
//  ChattingViewController.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/01/08.
//

import UIKit
//import RxSwift
//import RxCocoa

// 채팅 리스트 화면
class ChattingViewController: UIViewController {

    @IBOutlet weak var chatTableView: UITableView!
    var chattingList = [ChattingRoom]()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()


        if let chattingListUserdefault = UserDefaultsManager.chattingRoom{
            chattingList = chattingListUserdefault
        }
//        bindViewModel()
        // Do any additional setup after loading the view.
    }
    let viewModel = ChatListViewModel()
//    var disposeBag = DisposeBag()
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

    func setUI() {

    }
//    func bindViewModel() {
//        let input = ChatListViewModel.Input(
//            viewWillAppearEvent: self.rx.methodInvoked(#selector(UIViewController.viewWillAppear)).map { _ in })
//
//        let output = viewModel.transform(input: input, disposeBag: disposeBag)
//
//        output.chatroomList.bind(to: chatTableView.rx.items(
//            cellIdentifier: "ChatRoomCell",
//
//            cellType: ChatRoomListCell.self)) { (index: Int, element: ChatRoom, cell: ChatRoomListCell) in
////            cellType: ChatRoomListCell.self)) { (index: Int, element: TEST, cell: ChatRoomListCell) in
//                cell.nameLabel.text = "이름"
//                cell.lastMessageLabel.text = "안녕"
//                cell.timeLabel.text = "9/12"
//
////                cell.nameLabel.text = "\(element.id)"
////                cell.lastMessageLabel.text = element.lastChatMessage ?? ""
////                cell.timeLabel.text = element.createdDate
//
//        }.disposed(by: disposeBag)
//
//    }
}

extension ChattingViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // senderid > 내 계정 아이디가 아닌 accountid로
        var accountId = (chattingList[indexPath.row].senderAccountId == UserDefaults.standard.integer(forKey: "accountId")) ? chattingList[indexPath.row].receiver.id : chattingList[indexPath.row].senderAccountId
        APIService.shared.getDirectMessages(senderAccountId: accountId)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chattingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath) as? ChatRoomListCell else {
            return UITableViewCell()
        }
        
        cell.nameLabel.text = chattingList[indexPath.row].receiver.name
        cell.lastMessageLabel.text = chattingList[indexPath.row].message
        cell.timeLabel.text = chattingList[indexPath.row].lastModifiedDate
        cell.messageCountLabel.text = "1"
        
        return cell
    }
}
