//
//  RetailAppUITests.swift
//  RetailAppUITests
//
//  Created by Janak Shah on 15/03/2021.
//  Copyright © 2021 Marks and Spencer. All rights reserved.
//

import XCTest

class RetailAppUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func test_tappingProductCell_opensProductDetailsVC() throws {
        let app = XCUIApplication()
        app.launch()
        app.collectionViews.cells.matching(identifier: "product_item").element(boundBy: 0).tap()
        XCTAssertTrue(app.otherElements["product_details_view_controller_view"].waitForExistence(timeout: 2), "Not on ProductDetailsViewController")
    }

}
