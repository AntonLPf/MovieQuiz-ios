import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPreseterDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var yesButton: UIButton!
    
    @IBOutlet private weak var noButton: UIButton!
    
    // MARK: - Properties
    
    private let questionsAmount = 10
            
    private var currentQuestion: QuizQuestion?
    
    private var currentQuestionIndex = 0
    
    private var isGameFinished: Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    private var correctAnswers = 0
    
    private var logger = Logger()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        questionFactory = QuestionFactory()
        questionFactory?.delegate = self
                
        questionFactory?.requestNextQuestion()
        imageView.layer.cornerRadius = 20
    }
    
    // MARK: - QuestionFactoryDelegate
    
    private var questionFactory: QuestionFactoryProtocol?
    
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    // MARK: - AlertPreseterDelegate
    
    private var alertPresenter: AlertPresenterProtocol?
    
    func didDismissResultAlert() {
        restartQuiz()
    }
    
    // MARK: - Actions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        handle(givenAnswer: false)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        handle(givenAnswer: true)
    }
    
    // MARK: - Methods
    
    func getResultViewModel(from resultRecord: ResultsRecord) -> QuizResultsViewModel {
        var text = "Ваш результат: \(correctAnswers)/10"
        
        let numberOfQuizes = logger.getNumberOfRecords()
        text += "\nКоличество сыгранных квизов: \(numberOfQuizes)"
        
        if let bestResult = logger.getBestResult() {
            let numberOfCorrectAnswers = bestResult.numberOfCorrectAnswers
            let numberOfqQuestions = bestResult.numberOfqQuestions
            let dateString = formattedString(for: bestResult.date)
            
            text += "\nРекорд: \(numberOfCorrectAnswers)/\(numberOfqQuestions) (\(dateString))"
        }
        
        let averageAccuracy = logger.getAverageAccuracy()
        let accuracyString = getPercentageString(for: averageAccuracy)
        text += "\nСредняя точность: \(accuracyString)%"
        
        let viewModel = QuizResultsViewModel(
                    title: "Этот раунд окончен!",
                    text: text,
                    buttonText: "Сыграть ещё раз")
        return viewModel
    }
    
    func formattedString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        let formattedString = formatter.string(from: date)
        return formattedString
    }
    
    func getPercentageString(for percentage: Float) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: percentage as NSNumber)!
    }
        
    // MARK: - Private Methods
    
    private func showNextQuestionOrResults() {
        
        guard !isGameFinished else {
            showFinishAlert()
            return
        }
        
        moveToNextQuestion()
        
        enableButtons()
    }
    
    private func moveToNextQuestion() {
        currentQuestionIndex += 1
        
        questionFactory?.requestNextQuestion()
    }
        
    private func showFinishAlert() {
        let resultRecord = ResultsRecord(numberOfCorrectAnswers: correctAnswers,
                                         numberOfqQuestions: questionsAmount,
                                         date: Date())
        logger.add(resultRecord)
        
        let resultViewModel = getResultViewModel(from: resultRecord)
        
        alertPresenter = AlertPresenter()
        alertPresenter?.delegate = self
        
        let alertModel = AlertModel(title: resultViewModel.title,
                                    message: resultViewModel.text,
                                    buttonText: resultViewModel.buttonText) { }
        
        alertPresenter?.show(alertModel)
    }
    
    private func restartQuiz() {
        currentQuestionIndex = 0
        correctAnswers = 0
        questionFactory?.requestNextQuestion()
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderWidth = 0
    }
    
    private func handle(givenAnswer: Bool) {
        
        guard let currentQuestion else { return }
        
        let isCorrect = currentQuestion.correctAnswer == givenAnswer
        
        if isCorrect {
            correctAnswers += 1
        }
        
        showAnswerResult(isCorrect: isCorrect)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        disableButtons()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            self.showNextQuestionOrResults()
        }
    }
        
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                          question: model.text,
                          questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    private func disableButtons() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    private func enableButtons() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
}
