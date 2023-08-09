//
//  UserEntity+CoreDataProperties.swift
//  
//
//  Created by leeyeon2 on 2022/10/16.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var thumbnail: String?
    @NSManaged public var password: String?
    @NSManaged public var name: String?
    @NSManaged public var gender: String?
    @NSManaged public var email: String?
    @NSManaged public var accountId: Int
    @NSManaged public var mentee: Bool
    @NSManaged public var mentor: Bool
}
