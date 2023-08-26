//
//  PredictionUITest.swift
//  FlashFitMobileAppUITests
//
//  Created by user233619 on 8/26/23.
//

import XCTest

@testable import FlashFitMobileApp

final class PredictionUITest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testPredictedWeightAndBMI() throws {
            let selectedDate = Date()
            let predictedWeight: Double = 70.0
            let predictedBMI: Double = 25.0
            
            let view = PredictionView(
                selectedDate: Binding<Date>(get: { selectedDate }, set: { _ in }),
                predictedWeight: predictedWeight,
                predictedBMI: predictedBMI
            )
    
            let sut = try view.inspect().vStack().view(0).zStack().vStack(1)
            
            // Verify the predicted weight and BMI texts
            XCTAssertEqual(try sut.text(0).string(), "\(String(format: "%.1f", predictedWeight))")
            XCTAssertEqual(try sut.text(1).string(), "\(String(format: "%.1f", predictedBMI))")
        }

    
    func testSuggestionText() throws {
            let suggestion = "Healthy meal"
          
            let view = PredictionView(
                selectedDate: .constant(Date()),
                predictedWeight: 0,
                predictedBMI: 0,
                suggestion: suggestion
            )
            
    
            let sut = try view.inspect().vStack().view(1).zStack().vStack(0)
            
        
            XCTAssertEqual(try sut.text(1).string(), suggestion)
        }
}
