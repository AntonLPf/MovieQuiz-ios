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
    
    var correctAnswers = 0
    
    var questionFactory: QuestionFactoryProtocol?
    
    var currentQuestion: QuizQuestion?
    
    weak var viewController: MovieQuizViewController?
    
    func restartQuiz() {
        resetQuestionIndex()
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
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
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.switchToNextQuestion()
            self?.viewController?.show(quiz: viewModel)
            self?.viewController?.enableButtons()
        }
    }
    
    func moveToNextStep() {
        
        if isQuizFinished() {
            showQuizResults()
        } else {
            moveToNextQuestion()
        }
    }
    
    private func showQuizResults() {
        let resultRecord = GameRecord(correctAnswersCount: correctAnswers,
                                      questionsCount: questionsAmount, date: Date())
        
        try? viewController?.storageService?.addNew(record: resultRecord)
        
        if let resultViewModel = viewController?.getResultViewModel(from: resultRecord) {
            viewController?.showFinishAlert(model: resultViewModel)
        }
    }
    
    private func moveToNextQuestion() {
        viewController?.showLoadingIndicator()
        
        questionFactory?.requestNextQuestion()
    }
    
    private func didAnswer(isYes: Bool) {
        
        guard let currentQuestion else { return }
        
        viewController?.disableButtons()
        
        let isCorrect = currentQuestion.correctAnswer == isYes
        
        if isCorrect {
            correctAnswers += 1
        }
        
        viewController?.showAnswerResult(isCorrect: isCorrect)
    }
}
