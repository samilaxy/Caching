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

class CacheManager {
    static let shared = CacheManager()
    private init() {}
    var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 100//  100mb
        return cache
    }()
    
    func addToCache(image: UIImage, name: String) {
        imageCache.setObject(image, forKey: name as NSString)
        print("Added to cache")
    }
    
    func addFromCache( name: String) {
        imageCache.removeObject(forKey: name as NSString)
        print("Removed from cache")
    }
    
    func getFromCache( name: String) -> UIImage? {
       return  imageCache.object(forKey: name as NSString)
        print("get from cache")
    }
}
