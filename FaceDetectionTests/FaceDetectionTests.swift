//
//  FaceDetectionTests.swift
//  FaceDetectionTests
//
//  Created by 周辉 on 2019/2/18.
//  Copyright © 2019 FaiChou. All rights reserved.
//

import XCTest

class FaceDetectionTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
      var transform: CGAffineTransform!
      transform = CGAffineTransform(scaleX: 1, y: -1)
      transform = transform.translatedBy(x: 0, y: -100)
      print("T1: \(String(describing: transform))")
      
      transform = CGAffineTransform(translationX: 0, y: -100)
      transform = transform.scaledBy(x: 1, y: -1)
      print("T2: \(String(describing: transform))")
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
