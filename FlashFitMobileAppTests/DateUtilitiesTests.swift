//
//  DateUtilitiesTests.swift
//  FlashFitMobileAppTests
//
//  Created by Gayan Kalinga on 2023-08-27.
//

import XCTest
@testable import FlashFitMobileApp

class DateUtilitiesTests: XCTestCase {
    
    // Test the default format "dd-MMM-yyyy"
    func testGetDateWithDefaultFormat() {
        let inputDate = Date(timeIntervalSince1970: 1629954000) // A specific date in seconds
        let expectedDateString = "26-Aug-2021" // Change this according to the input date
        
        let result = DateUtilities.getDate(for: inputDate)
        
        XCTAssertEqual(result, expectedDateString)
    }
    
    // Test with a custom date format
    func testGetDateWithCustomFormat() {
        let inputDate = Date(timeIntervalSince1970: 1629954000) // A specific date in seconds
        let customFormat = "yyyy/MM/dd" // Change this to your custom format
        let expectedDateString = "2021/08/26" // Change this according to the input date and custom format
        
        let result = DateUtilities.getDate(for: inputDate, given: customFormat)
        
        XCTAssertEqual(result, expectedDateString)
    }
    
    // Add more test cases for different scenarios as needed
    
}

