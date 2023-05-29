//
//  ImageData+CoreDataProperties.swift
//  Caching
//
//  Created by Noye Samuel on 29/05/2023.
//
//

import Foundation
import CoreData
import UIKit


extension ImageData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageData> {
        return NSFetchRequest<ImageData>(entityName: "ImageData")
    }

    @NSManaged public var img: UIImage?
    @NSManaged public var createAt: Date?
    @NSManaged public var blur: NSObject?
    
}

extension ImageData : Identifiable {

}
