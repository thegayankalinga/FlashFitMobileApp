//
//  LoginViewUITests.swift
//  FlashFitMobileAppUITests
//
//  Created by Gayan Kalinga on 2023-08-26.
//

import XCTest

class LoginViewUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUp() {
        super.setUp()
        
        // Initialize the app with your app's bundle identifier
        app = XCUIApplication(bundleIdentifier: "com.yourapp.bundle")
        app.launch()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testLogin() {
        // Your test case for login functionality
        
        // Assuming your LoginView contains UI elements with accessibility identifiers,
        // you can access them using `app.buttons`, `app.textFields`, etc., and interact with them.
        
        let emailTextField = app.textFields["emailTextFieldIdentifier"]
        let passwordTextField = app.secureTextFields["passwordTextFieldIdentifier"]
        let loginButton = app.buttons["loginButtonIdentifier"]
        
        // Perform UI actions, for example:
        emailTextField.tap()
        emailTextField.typeText("bg15407@gmail.com")
        
        passwordTextField.tap()
        passwordTextField.typeText("gayan")
        
        loginButton.tap()
        
        // Use XCTestExpectation to wait for UI changes, alerts, or navigation.
        
        // Example expectation:
        let loggedInAlert = app.alerts["loggedInAlertIdentifier"]
        XCTAssertTrue(loggedInAlert.waitForExistence(timeout: 5), "Logged in successfully")

        // Add assertions to verify that the user is logged in, or navigate to another view if needed.
    }
}

