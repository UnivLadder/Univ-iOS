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

    func getUserInfo(ascending: Bool = false) -> [UserEntity] {
        var models: [UserEntity] = [UserEntity]()
        
        if let context = context {
            let codeSort: NSSortDescriptor = NSSortDescriptor(key: "code", ascending: ascending)
            let fetchRequest: NSFetchRequest<NSManagedObject>
            = NSFetchRequest<NSManagedObject>(entityName: modelNameSubjectEntity)
            fetchRequest.sortDescriptors = [codeSort]
            
            do {
                if let fetchResult: [UserEntity] = try context.fetch(fetchRequest) as? [UserEntity] {
                    models = fetchResult
                }
            } catch let error as NSError {
                print("Could not fetch🥺: \(error), \(error.userInfo)")
            }
        }
        return models
    }
    
    
    
    func getSubjectEntitys(ascending: Bool = false) -> [SubjectEntity] {
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
    
    func deleteUser(code: Int64, onSuccess: @escaping ((Bool) -> Void)) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = filteredRequest(code: code)
        
        do {
            if let results: [SubjectEntity] = try context?.fetch(fetchRequest) as? [SubjectEntity] {
                if results.count != 0 {
                    context?.delete(results[0])
                }
            }
        } catch let error as NSError {
            print("Could not fatch🥺: \(error), \(error.userInfo)")
            onSuccess(false)
        }
        
        contextSave { success in
            onSuccess(success)
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
