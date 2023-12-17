import UIKit

final class MovieQuizViewController: UIViewController, AlertPreseterDelegate {
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Outlets
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var yesButton: UIButton!
    
    @IBOutlet private weak var noButton: UIButton!
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private var presenter: MovieQuizPresenter!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.presenter = MovieQuizPresenter(viewController: self)
        
        imageView.layer.cornerRadius = 20
        
    }
    
    // MARK: - Actions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    // MARK: - AlertPreseterDelegate
    
    private var alertPresenter: AlertPresenterProtocol?
    
    func didDismissResultAlert() {
        presenter.restartQuiz()
        enableButtons()
    }
    
    func didDismissNetworkErrorAlert() {
        presenter.loadData()
        presenter.restartQuiz()
    }
    
    func didDismissQuestionLoadingErrorAlert() {
        presenter.moveToNextStep()
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
    
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
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
    
    func showNetworkError(message: String, alertType: AlertModel.AlertType) {
        alertPresenter = AlertPresenter()
        alertPresenter?.delegate = self
        
        let alertModel = AlertModel(title: "Ошибка",
                                    message: message,
                                    buttonText: "Попробовать ещё раз", type: alertType) {}
        
        alertPresenter?.show(alertModel)
    }
}
