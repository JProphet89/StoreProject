//
//  ProductListUITests.swift
//  ProductListUITests
//
//  Created by João Fonseca on 11/10/2022.
//

import XCTest

final class ProductListUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launchArguments = ["UITest"]
        app.launch()
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        app.terminate()
    }

    func testAddAndRemoveProductFromBagList() throws {
        // Wait for the list
        let productList = app.scrollViews["accessibilityProductList"]
        XCTAssertTrue(productList.waitForExistence(timeout: 3))
        // Add product to the list
        let productAddBagIcon = app.buttons["accessibilityProductAddButton"].firstMatch
        XCTAssertTrue(productAddBagIcon.waitForExistence(timeout: 3))
        XCTAssertTrue(productAddBagIcon.isHittable)
        productAddBagIcon.tap()
        // Go to bag
        let bagIcon = app.buttons["accessibilityBagIcon"]
        XCTAssertTrue(bagIcon.isHittable)
        bagIcon.tap()
        // Wait for the bag list
        let bagList = app.scrollViews["accessibilityBagList"]
        XCTAssertTrue(bagList.waitForExistence(timeout: 3))
        // Get First item on list
        let bagListItem = app.scrollViews["accessibilityBagListItem"].firstMatch
        XCTAssertTrue(bagListItem.waitForExistence(timeout: 3))
        // Get First item on list
        let removeButton = bagList.otherElements.buttons["accessibilityBagListItem"].firstMatch
        XCTAssertTrue(removeButton.waitForExistence(timeout: 3))
        XCTAssertTrue(removeButton.isHittable)
        removeButton.tap()
    }
}
