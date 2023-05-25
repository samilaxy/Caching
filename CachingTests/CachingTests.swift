//
//  CachingTests.swift
//  CachingTests
//
//  Created by Noye Samuel on 28/03/2023.
//

import XCTest
@testable import Caching

class CacheManagerTest: XCTestCase {
    
    var sut: CacheManager!
    
    override func setUp() {
        super.setUp()
        sut = CacheManager.shared
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testAddImageToCache() {
            // Given
        let key = "test_image"
        let image = UIImage(systemName: "photo")!
        
            // When
        sut.add(key: key, image: image)
        
            // Then
        XCTAssertNotNil(sut.get(key: key))
        XCTAssertEqual(sut.get(key: key), image)
    }
    func testGetMissingImageFromCache() {
            // Given
        let key = "missing_image"
            // When
        let result = sut.get(key: key)
            // Then
        XCTAssertNil(result)
    }
    
}
