//
//  LoginViewModelTests.swift
//  FlashFitMobileAppTests
//
//  Created by Gayan Kalinga on 2023-08-26.
//

import XCTest
import CoreData
@testable import FlashFitMobileApp // Import your app module here

class LoginViewModelTests: XCTestCase {

    // Define a variable for the managed object context
    var moc: NSManagedObjectContext!

    override func setUp() {
        super.setUp()

        // Initialize a managed object context for testing
        let persistentContainer = NSPersistentContainer(name: "YourDataModelName")
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        moc = persistentContainer.viewContext
    }

    override func tearDown() {
        // Clean up any resources after the tests
        moc = nil
        super.tearDown()
    }

    // Test the login method
    func testLogin() {
        // Create a test instance of LoginViewModel
        let loginViewModel = LoginViewModel()

        // Prepare a UserModelEntity (user) with known values
        let user = UserModelEntity(context: moc)
        user.email = "bg15407@gmail.com"
        user.name = "Gayan Kalinga Test User"
        // Set other user properties as needed for the test

        // You need to hash the password and set it in the user's passwordHash property.
        // This should match with the computed hash in the LoginViewModel

        // Save the user entity to the managed object context
        try! moc.save()

        do {
            // Attempt to log in with valid credentials
            let loggedInUser = try loginViewModel.login(email: "bg15407@gmail.com", password: "gayan", moc: moc)

            // Assert that the logged-in user matches the prepared user
            XCTAssertEqual(loggedInUser.email, user.email)
            XCTAssertEqual(loggedInUser.name, user.name)
            // Add additional assertions for other properties as needed
        } catch {
            // Handle any errors or failed assertions here
            XCTFail("Login should succeed with valid credentials")
        }
    }
}
