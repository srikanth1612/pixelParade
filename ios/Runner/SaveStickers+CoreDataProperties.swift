//
//  SaveStickers+CoreDataProperties.swift
//  
//
//  Created by Chethan Jayaram on 12/11/24.
//
//

import Foundation
import CoreData


extension SaveStickers:Decodable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SaveStickers> {
        return NSFetchRequest<SaveStickers>(entityName: "SaveStickers")
    }

    @NSManaged public var totalStickers: String?
    @NSManaged public var id: String?

}
