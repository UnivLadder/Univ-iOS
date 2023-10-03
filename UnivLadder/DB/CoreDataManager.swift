//
//  CoreDataManager.swift
//  UnivLadder
//
//  Created by leeyeon2 on 2022/04/24.
//

import UIKit
import CoreData

enum CoreDataName: String {
    case mento = "Mento"
}

class CoreDataManager {
    static let shared: CoreDataManager = CoreDataManager()
    
    private let appDelegate = UIApplication.shared.delegate as? AppDelegate
    private lazy var context = appDelegate?.persistentContainer.viewContext
    
    let modelNameUser: String = "UserEntity"
    let modelNameSubjectEntity: String = "SubjectEntity"
    
    // MARK: - User coredata 관리
    // 1. User 저장
    func saveUserEntity(accountId: Int, email: String, gender: String, name: String, password: String?, thumbnail: String?, mentee: Bool, mentor: Bool, onSuccess: @escaping ((Bool) -> Void)) {
        if let context = context {
            //1) entity 생성
            if let entity: NSEntityDescription = NSEntityDescription.entity(forEntityName: modelNameUser as String, in: context) {
                //2) 객체 생성
                if let UserEntity: UserEntity = NSManagedObject(entity: entity, insertInto: context) as? UserEntity {
                    UserEntity.accountId = accountId
                    UserEntity.email = email
                    UserEntity.gender = gender
                    UserEntity.name = name
                    UserEntity.password = password
                    UserEntity.thumbnail = thumbnail
                    UserEntity.mentee = mentee
                    UserEntity.mentor = mentor
                    // coredata 저장
                    contextSave { success in
                        onSuccess(success)
                    }
                }
            }
        }
    }
    
    // 2. User 조회
    func getUserInfo(ascending: Bool = false) -> [UserEntity] {
        var models = [UserEntity]()
        if let context = context {
            do {
                models = try context.fetch(UserEntity.fetchRequest())
            }
            catch let error as NSError {
                print("Could not fetch🥺: \(error), \(error.userInfo)")
            }
        }
        return models
    }
    
    // 3. User 이미지 변경사항 반영 수정
    func updateUserInfo(img: String, onSuccess: @escaping ((Bool) -> Void)) {
        let fetchResults = getUserInfo()
        for result in fetchResults {
            result.thumbnail = img
        }
        contextSave { success in
            onSuccess(success)
        }
    }
    
    // 4. User 이미지 변경사항 반영 수정
    func updateUserInfo(thumbnail: String, email: String, name: String, gender: String, onSuccess: @escaping ((Bool) -> Void)) {
        let fetchResults = getUserInfo()
        for result in fetchResults {
            result.gender = gender
            result.name = name
            result.email = email
            result.thumbnail = thumbnail
        }
        contextSave { success in
            onSuccess(success)
        }
    }
    
    // 5. 모든 User 삭제
    func deleteAllUsers() {
        let fetrequest = NSFetchRequest<NSFetchRequestResult>(entityName: modelNameUser)
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetrequest)
        
        do {
            if let context = context {
                try context.execute(batchDeleteRequest)
                print("기존 Users 데이터 모두 삭제 완료")
            }
            
        } catch {
            print(error)
        }
    }
    
    // MARK: - Subject coredata 관리
    // 1. Subject 저장
    func saveSubjectEntity(code: Int64, topic: String, value: String, onSuccess: @escaping ((Bool) -> Void)) {
        if let context = context {
            if let entity: NSEntityDescription = NSEntityDescription.entity(forEntityName: modelNameSubjectEntity as String, in: context) {
                
                if let SubjectEntity: SubjectEntity = NSManagedObject(entity: entity, insertInto: context) as? SubjectEntity {
                    SubjectEntity.code = code
                    SubjectEntity.topic = topic
                    SubjectEntity.value = value
                    
                    contextSave { success in
                        onSuccess(success)
                    }
                }
            }
        }
    }
    
    // 2. Subject 조회
    func getSubjectEntity(ascending: Bool = false) -> [SubjectEntity] {
        var models: [SubjectEntity] = [SubjectEntity]()
        if let context = context {
            let codeSort: NSSortDescriptor = NSSortDescriptor(key: "code", ascending: ascending)
            let fetchRequest: NSFetchRequest<NSManagedObject>
            = NSFetchRequest<NSManagedObject>(entityName: modelNameSubjectEntity)
            fetchRequest.sortDescriptors = [codeSort]
            
            do {
                if let fetchResult: [SubjectEntity] = try context.fetch(fetchRequest) as? [SubjectEntity] {
                    models = fetchResult
                }
            } catch let error as NSError {
                print("Could not fetch🥺: \(error), \(error.userInfo)")
            }
        }
        return models
    }
    
    // 3. 특정 Subject 삭제
    func deleteSubject(code: Int64, onSuccess: @escaping ((Bool) -> Void)) {
        
        let deleteRequest: NSFetchRequest<NSFetchRequestResult> = filteredRequest(code: code)
        do {
            if let results: [SubjectEntity] = try context?.fetch(deleteRequest) as? [SubjectEntity] {
                if results.count != 0 {
                    context?.delete(results[0])
                }
            }
        } catch let error as NSError {
            print("Could not fatch: \(error), \(error.userInfo)")
        }
        do {
            try context?.save()
            print("코어데이터 삭제 성공")
            return
        } catch {
            context?.rollback()
            print("실행 불가능 합니다")
            return
        }
        //        default: break
        
    }
    
    // 4. 모든 Subject 삭제
    func deleteAllSubject() {
        let fetrequest = NSFetchRequest<NSFetchRequestResult>(entityName: "SubjectEntity")
        // Batch는 한꺼번에 데이터처리를 할때 사용합니다. 지금의 경우 저장된 데이터를 모두 지우는 것입니다.
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetrequest)
        
        do {
            if let context = context {
                try context.execute(batchDeleteRequest)
                print("기존 Subject 데이터 모두 삭제 완료")
            }
            
        } catch {
            print(error)
        }
    }
    
}
extension CoreDataManager {
    fileprivate func filteredRequest(code: Int64) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
        = NSFetchRequest<NSFetchRequestResult>(entityName: modelNameSubjectEntity)
        fetchRequest.predicate = NSPredicate(format: "code = %@", NSNumber(value: code))
        return fetchRequest
    }
    
    fileprivate func contextSave(onSuccess: ((Bool) -> Void)) {
        do {
            try context?.save()
            onSuccess(true)
        } catch let error as NSError {
            print("Could not save🥶: \(error), \(error.userInfo)")
            onSuccess(false)
        }
    }
}
