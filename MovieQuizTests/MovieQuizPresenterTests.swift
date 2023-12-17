//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by Антон Шишкин on 18.12.23.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func showFinishAlert(model: MovieQuiz.QuizResultsViewModel) {
        
    }
    
    func show(quiz step: MovieQuiz.QuizStepViewModel) {
        
    }
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        
    }
    
    func disableButtons() {
        
    }
    
    func enableButtons() {
        
    }
    
    func showLoadingIndicator() {
        
    }
    
    func hideLoadingIndicator() {
        
    }
    
    func showNetworkError(message: String, alertType: MovieQuiz.AlertModel.AlertType) {
        
    }
}

final class MovieQuizPresenterTests: XCTestCase {
    
    var sut: MovieQuizPresenter!

    override func setUpWithError() throws {
        try super.setUpWithError()
        let viewControllerMock = MovieQuizViewControllerMock()
        sut = MovieQuizPresenter(viewController: viewControllerMock)
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testPresenterConvertModel() throws {
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
        
    }
}
