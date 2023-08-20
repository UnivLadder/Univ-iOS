//
//  UserDefaultsManager.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2023/06/01.
//

import Foundation

struct UserDefaultsManager {
    @UserDefaultWrapper(key: "subjectList", defaultValue: nil)
    static var subjectList: [SubjectModel]?
    
    @UserDefaultWrapper(key: "categoryList", defaultValue: nil)
    static var categoryList: [String]?
    
    @UserDefaultWrapper(key: "subjectDictionary", defaultValue: nil)
    static var subjectDictionary: [String:[String]]?
    
    @UserDefaultWrapper(key: "recommendMentor", defaultValue: nil)
    static var recommendMentorList: [RecommendMentor]?
    
    @UserDefaultWrapper(key: "chattingRoom", defaultValue: nil)
    static var chattingRoom: [ChattingRoom]?

    @UserDefaultWrapper(key: "chatting", defaultValue: nil)
    static var chatting: [ChattingRoom]?
    
    @UserDefaultWrapper(key: "mentoSubject", defaultValue: nil)
    static var mentoSubject: [MentoSubject]?
    
    @UserDefaultWrapper(key: "mentorSubjectList", defaultValue: nil)
    static var mentorSubjectList: [String]?
    
    @UserDefaultWrapper(key: "subjectHash", defaultValue: nil)
    static var subjectHash: Dictionary<Int,[Int]>?
}

@propertyWrapper
struct UserDefaultWrapper<T: Codable> {
    private let key: String
    private let defaultValue: T?

    init(key: String, defaultValue: T?) {
        self.key = key
        self.defaultValue = defaultValue
    }
    
    var wrappedValue: T? {
        get {
            if let savedData = UserDefaults.standard.object(forKey: key) as? Data {
                let decoder = JSONDecoder()
                if let lodedObejct = try? decoder.decode(T.self, from: savedData) {
                    return lodedObejct
                }
            }
            return defaultValue
        }
        set {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(newValue) {
                UserDefaults.standard.setValue(encoded, forKey: key)
            }
        }
    }
}
