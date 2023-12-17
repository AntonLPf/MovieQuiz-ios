//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 17.12.23.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {
    private let staticticService: QuizStatisticServiceProtocol!
    private let storage: QuizStorageProtocol!
    private var questionFactory: QuestionFactoryProtocol?
    private weak var viewController: MovieQuizViewController?
    
    private var currentQuestion: QuizQuestion?
    private let questionsAmount = 10
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    
    init(viewController: MovieQuizViewController) {
        self.viewController = viewController
        self.staticticService = StatisticService()
        self.storage = QuizStorage()
        self.questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), imageLoader: ImageLoader(), delegate: self)
        loadData()
    }
    
    // MARK: - QuestionFactoryDelegate
    
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
    
    func didLoadDataFromServer() {
        viewController?.hideLoadingIndicator()
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.hideLoadingIndicator()
        viewController?.showNetworkError(message: error.localizedDescription, alertType: .networkError)
    }
    
    func didFailLoadQuestion() {
        viewController?.hideLoadingIndicator()
        viewController?.showNetworkError(message: "Не удалось загрузить вопрос", alertType: .questionLoadingError)
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
    
    // MARK: - Private methods
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(image: UIImage(data: model.image) ?? UIImage(),
                          question: model.text,
                          questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func getResultViewModel(from quizStatistics: QuizStatistics) -> QuizResultsViewModel {
        var text = "Ваш результат: \(correctAnswers)/10"
        
        text += "\nКоличество сыгранных квизов: \(quizStatistics.numberOfGames)"
        
        let bestResult = quizStatistics.bestGame
        let numberOfCorrectAnswers = bestResult.correctAnswersCount
        let numberOfqQuestions = bestResult.questionsCount
        let dateString = getFormattedString(for: bestResult.date)
        
        text += "\nРекорд: \(numberOfCorrectAnswers)/\(numberOfqQuestions) (\(dateString))"
        
        text += "\nСредняя точность: \(String(format: "%.2f", quizStatistics.totalAccuracy))%"
        
        let viewModel = QuizResultsViewModel(
            title: "Этот раунд окончен!",
            text: text,
            buttonText: "Сыграть ещё раз")
        
        return viewModel
    }
    
    private func proceedToResults() {
        let resultRecord = GameRecord(correctAnswersCount: correctAnswers,
                                      questionsCount: questionsAmount, date: Date())
        
        try? storage.addNew(record: resultRecord)
        
        if let quizDb = try? storage.loadDb() {
            
            let quizStatistics = staticticService.getQuizStatistics(from: quizDb)
            let resultViewModel = getResultViewModel(from: quizStatistics)
            
            viewController?.showFinishAlert(model: resultViewModel)
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
}
