import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate, AlertPreseterDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var yesButton: UIButton!
    
    @IBOutlet private weak var noButton: UIButton!
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private let presenter = MovieQuizPresenter()
                        
    private var staticticService: StatisticServiceProtocol?
    
    var storageService: StorageProtocol?
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        presenter.viewController = self
        
        presenter.questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), imageLoader: ImageLoader(), delegate: self)

        imageView.layer.cornerRadius = 20
        

        let storageService = Storage()
        
        self.storageService = storageService
        
        staticticService = StatisticService(store: storageService)
        
        loadData()
    }
    
    // MARK: - QuestionFactoryDelegate
        
    func didReceiveNextQuestion(question: QuizQuestion?) {
        presenter.didReceiveNextQuestion(question: question)
    }
    
    func didLoadDataFromServer() {
        hideLoadingIndicator()
        presenter.questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        hideLoadingIndicator()
        showNetworkError(message: error.localizedDescription, alertType: .networkError)
    }
    
    func didFailLoadQuestion() {
        hideLoadingIndicator()
        showNetworkError(message: "Не удалось загрузить вопрос", alertType: .questionLoadingError)
    }
    
    // MARK: - AlertPreseterDelegate
    
    private var alertPresenter: AlertPresenterProtocol?
    
    func didDismissResultAlert() {
        presenter.restartQuiz()
        enableButtons()
    }
    
    func didDismissNetworkErrorAlert() {
        loadData()
        presenter.restartQuiz()
    }
    
    func didDismissQuestionLoadingErrorAlert() {
        presenter.moveToNextStep()
    }
    
    // MARK: - Actions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    // MARK: - Methods
    
    func getResultViewModel(from gameRecord: GameRecord) -> QuizResultsViewModel {
        var text = "Ваш результат: \(presenter.correctAnswers)/10"
        
        let numberOfQuizes = staticticService?.gamesCount ?? 0
        text += "\nКоличество сыгранных квизов: \(numberOfQuizes)"
        
        if let bestResult = staticticService?.bestGame {
            let numberOfCorrectAnswers = bestResult.correctAnswersCount
            let numberOfqQuestions = bestResult.questionsCount
            let dateString = getFormattedString(for: bestResult.date)
            
            text += "\nРекорд: \(numberOfCorrectAnswers)/\(numberOfqQuestions) (\(dateString))"
        }
        
        let averageAccuracy = staticticService?.totalAccuracy ?? 0.0
        text += "\nСредняя точность: \(String(format: "%.2f", averageAccuracy))%"
        
        let viewModel = QuizResultsViewModel(
            title: "Этот раунд окончен!",
            text: text,
            buttonText: "Сыграть ещё раз")
        return viewModel
    }
    
    // MARK: - Private Methods
    
    private func getFormattedString(for date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        let formattedString = formatter.string(from: date)
        return formattedString
    }
    
    private func loadData() {
        showLoadingIndicator()
        presenter.questionFactory?.loadData()
    }
    
    func showFinishAlert(model: QuizResultsViewModel) {
        alertPresenter = AlertPresenter()
        alertPresenter?.delegate = self
        
        let alertModel = AlertModel(title: model.title,
                                    message: model.text,
                                    buttonText: model.buttonText,
                                    type: .result) { }
        
        alertPresenter?.show(alertModel)
    }
        
    func show(quiz step: QuizStepViewModel) {
        hideLoadingIndicator()
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderWidth = 0
        enableButtons()
    }
        
    func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            
            guard let self = self else { return }
            
            presenter.moveToNextStep()
        }
    }
        
    func disableButtons() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    func enableButtons() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    private func showNetworkError(message: String, alertType: AlertModel.AlertType) {
        alertPresenter = AlertPresenter()
        alertPresenter?.delegate = self
        
        let alertModel = AlertModel(title: "Ошибка",
                                    message: message,
                                    buttonText: "Попробовать ещё раз", type: alertType) {}
        
        alertPresenter?.show(alertModel)
    }
}
