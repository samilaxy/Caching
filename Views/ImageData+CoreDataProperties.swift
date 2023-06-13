//
//  ImageData+CoreDataProperties.swift
//  Caching
//
//  Created by Noye Samuel on 12/06/2023.
//
//

import Foundation
import CoreData
import UIKit


extension ImageData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageData> {
        return NSFetchRequest<ImageData>(entityName: "ImageData")
    }

    @NSManaged public var blur: NSObject?
    @NSManaged public var createAt: Date?
    @NSManaged public var img: UIImage?
    @NSManaged public var favorite: Bool

}

extension ImageData : Identifiable {

}
