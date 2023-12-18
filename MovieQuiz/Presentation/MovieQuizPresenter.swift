//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 17.12.23.
//

import UIKit

final class MovieQuizPresenter {
    private let staticticService: QuizStatisticServiceProtocol!
    private let storage: QuizStorageProtocol!
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewControllerProtocol?
    
    private var currentQuestion: QuizQuestion?
    private let questionsAmount = 10
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        self.staticticService = StatisticService()
        self.storage = QuizStorage()
        self.questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), imageLoader: ImageLoader(), delegate: self)
        loadData()
    }
    
    // MARK: - Methods
    
    func loadData() {
        viewController?.showLoadingIndicator()
        questionFactory?.loadData()
    }
    
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
    
    func yesButtonClicked() {
        didAnswer(isYes: true)
    }
    
    func noButtonClicked() {
        didAnswer(isYes: false)
    }
    
    func moveToNextStep() {
        
        if isQuizFinished() {
            proceedToResults()
        } else {
            proceedToNextQuestion()
        }
    }
    
    func convert(model: QuizQuestion) -> QuizQuestionViewModel {
        
        let image = UIImage(data: model.image) ?? UIImage()
        let text = model.text
        let number = "\(currentQuestionIndex + 1)/\(questionsAmount)"
        
        let vm = QuizQuestionViewModel(image: image, text: text, number: number)
        
        return vm
    }
    
    // MARK: - Private methods
    
    private func getInterruptionAlertModel(message: String, reason: QuizInterruptionReason) -> AlertModel {
        var alertModel = AlertModel(title: "Ошибка",
                                    message: message,
                                    buttonText: "Попробовать ещё раз", 
                                    type: .quizLoadingError)
        
        switch reason {
        case .quizLoadingError:
            alertModel.type = .quizLoadingError
        case .questionLoadingError:
            alertModel.type = .questionLoadingError
        }
        return alertModel
    }
    
    private func getResultAlertModel(from quizStatistics: QuizStatistics) -> AlertModel {
        var text = "Ваш результат: \(correctAnswers)/10"
        
        text += "\nКоличество сыгранных квизов: \(quizStatistics.numberOfGames)"
        
        let bestResult = quizStatistics.bestGame
        let numberOfCorrectAnswers = bestResult.correctAnswersCount
        let numberOfqQuestions = bestResult.questionsCount
        let dateString = getFormattedString(for: bestResult.date)
        
        text += "\nРекорд: \(numberOfCorrectAnswers)/\(numberOfqQuestions) (\(dateString))"
        
        text += "\nСредняя точность: \(String(format: "%.2f", quizStatistics.totalAccuracy))%"
        
        let viewModel = AlertModel(title: "Этот раунд окончен!",
                                   message: text,
                                   buttonText: "Сыграть ещё раз",
                                   type: .quizResult)
        
        return viewModel
    }
    
    private func proceedToResults() {
        let resultRecord = GameRecord(correctAnswersCount: correctAnswers,
                                      questionsCount: questionsAmount, date: Date())
        
        try? storage.addNew(record: resultRecord)
        
        if let quizDb = try? storage.loadDb() {
            
            let quizStatistics = staticticService.getQuizStatistics(from: quizDb)
            let resultAlertViewModel = getResultAlertModel(from: quizStatistics)
            
            viewController?.showAlert(model: resultAlertViewModel)
        }
        
    }
    
    private func proceedToNextQuestion() {
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
        
        proceedWithAnswer(isCorrect: isCorrect)
    }
    
    private func getFormattedString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        let formattedString = formatter.string(from: date)
        return formattedString
    }
    
    private func proceedWithAnswer(isCorrect: Bool) {
        viewController?.highlightImageBorder(isCorrectAnswer: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            
            guard let self = self else { return }
            
            moveToNextStep()
        }
    }
    
    enum QuizInterruptionReason {
        case quizLoadingError
        case questionLoadingError
    }
}

extension MovieQuizPresenter: QuestionFactoryDelegate {
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        
        currentQuestion = question
        let questionViewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.switchToNextQuestion()
            self?.viewController?.show(question: questionViewModel)
            self?.viewController?.enableButtons()
        }
    }
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.hideLoadingIndicator()
        let alertModel = getInterruptionAlertModel(message: error.localizedDescription, reason: .quizLoadingError)
        viewController?.showAlert(model: alertModel)
    }
    
    func didFailLoadQuestion() {
        viewController?.hideLoadingIndicator()
        let alertModel = getInterruptionAlertModel(message: "Не удалось загрузить вопрос", reason: .questionLoadingError)
        viewController?.showAlert(model: alertModel)
    }
    
}
