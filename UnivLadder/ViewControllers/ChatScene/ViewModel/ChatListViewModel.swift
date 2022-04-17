//
//  ChatListViewModel.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2022/04/17.
//

import Foundation
import RxSwift
import RxRelay

final class ChatListViewModel: ViewModelType {
    let items = BehaviorRelay<[ChatRoom]>(value: [])
    
    func transform(input: Input, disposeBag: DisposeBag) -> Output {
        let output = Output()
        
        input.viewWillAppearEvent
            .subscribe(onNext: { [weak self] in
                self?.fetchChatList()
            })
            .disposed(by: disposeBag)
        
        items.subscribe(onNext: { [weak self] chatrooms in
            output.chatroomList.accept(chatrooms)
            })
            .disposed(by: disposeBag)
        
        return output
    }
    
    func fetchChatList() {
        let params = ["criteria": "CREATE"]
        APIService.shared.get(
            requestTask: .chats,
            parameters: params,
            responseType: [ChatRoom].self) { [weak self] result in
                switch result {
                case .success(let chatrooms):
                    self?.items.accept(chatrooms)
                case .failure(let error):
                    print(error)
                }
            }
    }
}

extension ChatListViewModel {
    struct Input {
        let viewWillAppearEvent: Observable<Void>
    }
    
    struct Output {
        let chatroomList = BehaviorRelay<[ChatRoom]>(value: [])
    }
}

