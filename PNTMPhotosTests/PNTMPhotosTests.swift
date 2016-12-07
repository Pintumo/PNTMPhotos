//
//  PNTMPhotosTests.swift
//  PNTMPhotosTests
//
//  Created by Evangelos Sismanidis on 06.12.16.
//  Copyright © 2016 Pintumo. All rights reserved.
//

import XCTest
import PNTMPhotos
@testable import PNTMPhotos

class PNTMPhotosTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let photoManager = PNTMPhotosManager.init(ForAlbum: "Test")
        let fetchResult = photoManager.allPhotos()
        XCTAssert(fetchResult.count == 0)
        
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
