//
//  Subject+CoreDataProperties.swift
//  
//
//  Created by leeyeon2 on 2022/04/24.
//
//

import Foundation
import CoreData


extension Subject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Subject> {
        return NSFetchRequest<Subject>(entityName: "Subject")
    }

    @NSManaged public var code: Int64
    @NSManaged public var topic: String?
    @NSManaged public var value: String?

}
