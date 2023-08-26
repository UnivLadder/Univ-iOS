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
        self.navigationItem.title = "과외 문의"
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
        let accountId = (chattingList[indexPath.row].sender.id == UserDefaults.standard.integer(forKey: "accountId")) ? chattingList[indexPath.row].receiver.id : chattingList[indexPath.row].sender.id
        let userName = (chattingList[indexPath.row].sender.id == UserDefaults.standard.integer(forKey: "accountId")) ? self.chattingList[indexPath.row].receiver.name : chattingList[indexPath.row].sender.name
        
        APIService.shared.getDirectMessages(myaccessToken: UserDefaults.standard.string(forKey: "accessToken")!, senderAccountId: accountId, completion: { res in
            guard let ChatRoomVC = self.storyboard?.instantiateViewController(withIdentifier: "ChatRoomViewController") as? ChatRoomViewController
            else { return }
            ChatRoomVC.allChatting = res
            ChatRoomVC.userName = userName
            ChatRoomVC.userAccount = accountId
            self.navigationController?.pushViewController(ChatRoomVC, animated: true)

        })

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chattingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRoomCell", for: indexPath) as? ChatRoomListCell else {
            return UITableViewCell()
        }
        
        // 대화방 타이틀 무조건 상대 이름
        // senderAccountId 보낸 사람이 나이면 > rereceiver name 가져오면 된당
        if (chattingList[indexPath.row].senderAccountId == UserDefaults.standard.integer(forKey: "accountId")){
            // senderAccountId 보낸 사람이 나이면
            cell.nameLabel.text = self.chattingList[indexPath.row].receiver.name
        }else{
            // 내가 아니면 senderAccountId 로 계정 조회 해서 이름 가져와야대
            cell.nameLabel.text = self.chattingList[indexPath.row].sender.name
        }
        
        cell.lastMessageLabel.text = self.chattingList[indexPath.row].message
        cell.timeLabel.text = self.chattingList[indexPath.row].lastModifiedDate.toDate()?.toString()
        cell.messageCountLabel.text = "1"
        
        return cell
    }
}
