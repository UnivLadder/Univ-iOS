//
//  SocketManager.swift
//  UnivLadder
//
//  Created by Ahyeonway on 2022/04/03.
//

import Foundation
//import SocketIO

class SocketIOManager: NSObject {
//    let token = ""
//
//    static let shared = SocketIOManager()
//    
//    // 서버와 메시지를 주고받기 위한 클래스
//    var manager: SocketManager!
//    
//    // 클라이언트 소켓
//    var socket: SocketIOClient!
//    
//    override init() {
//        super.init()
//        
//        let url = URL(string: Endpoint.baseURL + "/chats")!
//        
//        manager = SocketManager(socketURL: url, config: [
//            .log(true),
//            .compress,
//            .extraHeaders(["Authentication": "Bearer \(UserDefaults.standard.string(forKey: "AccessKey"))"])
//        ])
//        
//        socket = manager.defaultSocket
//        
//        // 소켓 연결 메서드
//        socket.on(clientEvent: .connect) { data, ack in
//            print("SOCKET CONNECTED", data, ack)
//        }
//        
//        // 소켓 연결 해제 메서드
//        socket.on(clientEvent: .disconnect) { data, ack in
//            print("SOCKET DISCONNETED", data, ack)
//        }
//        
//        // 소켓 채팅 듣는 매서드
//        socket.on("sesac") { dataArray, ack in
//            print("chat!!", dataArray)
//            
//            // 알람
//        }
//    }
//    
//    func establishConnection() {
//        socket.connect()
//    }
//    
//    func closeConnection() {
//        socket.disconnect()
//    }
}
