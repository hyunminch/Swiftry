//
//  SwiftryTests.swift
//  SwiftryTests
//
//  Created by Hyun Min Choi on 2016. 10. 26..
//  Copyright © 2016년 Hyun Min Choi. All rights reserved.
//

import XCTest
@testable import Swiftry

class SwiftryTests: XCTestCase {
    
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
        let swiftry = Swiftry<Int>(value: 3)
        XCTAssert(swiftry.isSuccessful)
    }
    
}
