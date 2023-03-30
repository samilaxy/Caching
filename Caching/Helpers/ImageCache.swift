//
//  ImageCache.swift
//  Caching
//
//  Created by Noye Samuel on 29/03/2023.
//

import Foundation
import UIKit

class ImageCache {
    static let shared = ImageCache()
    
    private let cache = NSCache<NSString, UIImage>()
    
    subscript(_ key: String) -> UIImage? {
        get { cache.object(forKey: NSString(string: key)) }
        set { newValue == nil ? cache.removeObject(forKey: NSString(string: key)) : cache.setObject(newValue!, forKey: NSString(string: key)) }
    }
}
