//
//  History+CoreDataProperties.swift
//  UIForTranslator
//
//  Created by Hana  Demas on 20/02/16.
//  Copyright © 2016 ___HANADEMAS___. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension History {

    @NSManaged var sourceText: String?
    @NSManaged var targetText: String?
    @NSManaged var sourceLan: String?
    @NSManaged var targetLan: String?

}
