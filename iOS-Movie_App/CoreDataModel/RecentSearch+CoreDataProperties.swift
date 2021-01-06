//
//  RecentSearch+CoreDataProperties.swift
//  iOS-Movie_App
//
//  Created by Sravanti on 10/12/20.
//
//

import Foundation
import CoreData


extension RecentSearch {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecentSearch> {
        return NSFetchRequest<RecentSearch>(entityName: "RecentSearch")
    }

    @NSManaged public var item: String?

}

extension RecentSearch: Identifiable {

}
