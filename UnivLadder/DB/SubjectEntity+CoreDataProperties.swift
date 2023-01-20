//
//  SubjectEntity+CoreDataProperties.swift
//  
//
//  Created by leeyeon2 on 2022/10/16.
//
//

import Foundation
import CoreData


extension SubjectEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SubjectEntity> {
        return NSFetchRequest<SubjectEntity>(entityName: "SubjectEntity")
    }

    @NSManaged public var code: Int64
    @NSManaged public var topic: String?
    @NSManaged public var value: String?

}
