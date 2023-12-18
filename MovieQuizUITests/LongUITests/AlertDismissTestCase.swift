//
//  AlertDismissTestCase.swift
//  MovieQuizUITests
//
//  Created by Антон Шишкин on 18.12.23.
//

import XCTest

final class AlertDismissTestCase: XCTestCase {

    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    func testAlertDismiss() {
        sleep(2)
        for _ in 1...10 {
            let randomButtonName = Bool.random() ? "Yes" : "No"
            app.buttons[randomButtonName].tap()
            sleep(2)
        }
        
        let alert = app.alerts["quizResult"]
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertTrue(indexLabel.label == "1/10")
    }
}
