//
//  UserDefaultManager.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/04/10.
//

import Foundation

@propertyWrapper
struct UserDefault<T> {
    private let key: String
    private let defaultValue: T

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            // Read value from UserDefaults
            return UserDefaults.standard.object(forKey: key) as? T ?? defaultValue
        }
        set {
            // Set value to UserDefaults
            UserDefaults.standard.set(newValue, forKey: key)
        }
    }
}

struct UserInfo {
    @UserDefault<String>(key: "accessToken", defaultValue: "")
    static var accessToken: String
}

