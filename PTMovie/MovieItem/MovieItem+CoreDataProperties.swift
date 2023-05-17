//
//  MovieItem+CoreDataProperties.swift
//  PTMovie
//
//  Created by Jons on 2023/5/17.
//
//

import Foundation
import CoreData


extension MovieItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieItem> {
        return NSFetchRequest<MovieItem>(entityName: "MovieItem")
    }

    @NSManaged public var id: Int64
    @NSManaged public var overViewStr: String?
    @NSManaged public var posterImageData: Data?
    @NSManaged public var releaseStr: String?
    @NSManaged public var titleString: String?

}

extension MovieItem : Identifiable {

}
