//
//  MealObject+CoreDataProperties.swift
//  MealFetcher
//
//  Created by ashley canty on 11/5/23.
//
//

import Foundation
import CoreData


extension MealObject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MealObject> {
        return NSFetchRequest<MealObject>(entityName: "MealObject")
    }

    @NSManaged public var meal_name: String?
    @NSManaged public var meal_id: String?
    @NSManaged public var meal_thumb: String?

}

extension MealObject : Identifiable {

}
