//
//  AlertPresentingTestCase.swift
//  MovieQuizUITests
//
//  Created by Антон Шишкин on 18.12.23.
//

import XCTest

final class AlertPresentingTestCase: XCTestCase {

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
    
    func testAlertPresenting() {
        sleep(2)
        for _ in 1...10 {
            let randomButtonName = Bool.random() ? "Yes" : "No"
            app.buttons[randomButtonName].tap()
            sleep(4)
        }
        
        let alert = app.alerts["quizResult"]
        
        XCTAssertTrue(alert.exists)
        XCTAssertTrue(alert.label == "Этот раунд окончен!")
        XCTAssertTrue(alert.buttons.firstMatch.label == "Сыграть ещё раз")
        
    }
}
