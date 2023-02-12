//
//  ChattingViewController.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/01/08.
//

import UIKit
//import RxSwift
//import RxCocoa

class ChattingViewController: UIViewController {

    @IBOutlet weak var chatTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
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

    }
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
