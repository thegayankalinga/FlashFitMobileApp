//
//  BMICalculatorTests.swift
//  FlashFitMobileAppTests
//
//  Created by Gayan Kalinga on 2023-08-12.
//

import Foundation
import XCTest

class BMICalculatorTests: XCTestCase {

    func testCalculateBMI() {
        // Test case 1
        XCTAssertEqual(calculateBmi(weight: 70, height: 170), 24.22145328719723, accuracy: 0.0001)
        
        // Test case 2
        XCTAssertEqual(calculateBmi(weight: 80, height: 180), 24.691358024691358, accuracy: 0.0001)
        
        // Test case 3
        XCTAssertEqual(calculateBmi(weight: 50, height: 160), 19.531249999999996, accuracy: 0.0001)
    }
    
    static var allTests = [
        ("testCalculateBMI", testCalculateBMI),
    ]
}
