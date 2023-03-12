//
//  KeyChain.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/01/20.
//

import UIKit

class KeyChain {
    // MARK: Shared instance
    static let shared = KeyChain()
    
    // MARK: Keychain
    static let serviceName = "서비스이름"
    static let account = "계정이름"
    
    //생성
    //SecItemAdd(_:_:) 함수를 사용해 키체인 아이템을 생성하고 성공했을 때 true를 반환.
    //id : , token : 사용자의 accessToken 값
    func addItem(id: String, token: String) -> Bool {
        let addQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                   kSecAttrAccount: id,
                                     kSecValueData: (token as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any]
        
        let result: Bool = {
            let status = SecItemAdd(addQuery as CFDictionary, nil)
            if status == errSecSuccess {
                return true
            } else if status == errSecDuplicateItem {
                return updateItem(value: token, id: id)
            }
            
            print("addItem Error : \(status.description))")
            return false
        }()
        
        return result
    }
    
    //조회
    //SecItemCopyMatching(_:_:)함수를 사용해 키체인 아이템을 조회하여 성공했을 때 User를 반환
    func getItem(id: Any) -> String? {
        let query: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                kSecAttrAccount: id,
                           kSecReturnAttributes: true,
                                 kSecReturnData: true]
        var item: CFTypeRef?
        let result = SecItemCopyMatching(query as CFDictionary, &item)
        
        if result == errSecSuccess {
            if let existingItem = item as? [String: Any],
               let data = existingItem[kSecValueData as String] as? Data,
               let password = String(data: data, encoding: .utf8) {
                return password
            }
        }
        
        print("getItem Error : \(result.description)")
        return nil
    }
    
    //수정
    //SecItemUpdate(_:_:)함수를 사용해 키체인 아이템을 수정하고 성공했을 때 true를 반환
    func updateItem(value: Any, id: Any) -> Bool {
        let prevQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                    kSecAttrAccount: id]
        let updateQuery: [CFString: Any] = [kSecValueData: (value as AnyObject).data(using: String.Encoding.utf8.rawValue) as Any]
        
        let result: Bool = {
            let status = SecItemUpdate(prevQuery as CFDictionary, updateQuery as CFDictionary)
            if status == errSecSuccess { return true }
            
            print("updateItem Error : \(status.description)")
            return false
        }()
        
        return result
    }
    
    //삭제
    //SecItemDelete(_:)함수를 사용해 키체인 아이템을 삭제하고 성공했을 때 true를 반환
    func deleteItem(id: String) -> Bool {
        let deleteQuery: [CFString: Any] = [kSecClass: kSecClassGenericPassword,
                                      kSecAttrAccount: id]
        let status = SecItemDelete(deleteQuery as CFDictionary)
        if status == errSecSuccess { return true }
        
        print("deleteItem Error : \(status.description)")
        return false
    }
}
