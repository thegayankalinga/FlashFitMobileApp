//
//  HealthStatusTests.swift
//  FlashFitMobileAppTests
//
//  Created by Gayan Kalinga on 2023-08-12.
//

import Foundation
import XCTest


class HealthStatusTests: XCTestCase {
    
    func testUnderweight() {
        XCTAssertEqual(getHealthStatus(bodyMassIndexValue: 15.0), HealthStatusEnum.Underweight)
    }
    
    func testNormalweight() {
        XCTAssertEqual(getHealthStatus(bodyMassIndexValue: 22.0), .Normalweight)
    }
    
    func testOverweight() {
        XCTAssertEqual(getHealthStatus(bodyMassIndexValue: 27.0), .Overweight)
    }
    
    func testObesity() {
        XCTAssertEqual(getHealthStatus(bodyMassIndexValue: 35.0), .Obesity)
    }
    
    func testNone() {
        XCTAssertEqual(getHealthStatus(bodyMassIndexValue: 10.0), .None)
        XCTAssertEqual(getHealthStatus(bodyMassIndexValue: -5.0), .None)
    }
}
