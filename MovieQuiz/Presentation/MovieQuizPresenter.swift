//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 17.12.23.
//

import UIKit

final class MovieQuizPresenter {
    
    let questionsAmount = 10
    
    private var currentQuestionIndex = 0
    
    var currentQuestion: QuizQuestion?
    
    weak var viewController: MovieQuizViewController?
    
    func isQuizFinished() -> Bool {
        currentQuestionIndex == questionsAmount
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                          question: model.text,
                          questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    func yesButtonClicked() {
        handle(givenAnswer: true)
    }
    
    func noButtonClicked() {
        handle(givenAnswer: false)
    }
    
    
    private func handle(givenAnswer: Bool) {
        
        guard let currentQuestion else { return }
        
        viewController?.disableButtons()
        
        let isCorrect = currentQuestion.correctAnswer == givenAnswer
        
        if isCorrect {
            viewController?.correctAnswers += 1
        }
        
        viewController?.showAnswerResult(isCorrect: isCorrect)
    }
}
