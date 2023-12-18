import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var yesButton: UIButton!
    
    @IBOutlet private weak var noButton: UIButton!
    
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    private var presenter: MovieQuizPresenter!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.presenter = MovieQuizPresenter(viewController: self)
        
        imageView.layer.cornerRadius = 20
        
    }
    
    // MARK: - Actions
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter.noButtonClicked()
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        presenter.yesButtonClicked()
    }
    
    // MARK: - Methods
    
    func show(question: QuizQuestionViewModel) {
        hideLoadingIndicator()
        imageView.image = question.image
        textLabel.text = question.text
        counterLabel.text = question.number
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
    
    func showAlert(model: AlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        alert.view.accessibilityIdentifier = model.type.rawValue
        
        let action: UIAlertAction = switch model.type {
        case .quizResult:
            UIAlertAction(title: model.buttonText, style: .default) { _ in
                self.presenter.restartQuiz()
                self.enableButtons()
            }
        case .quizLoadingError:
            UIAlertAction(title: model.buttonText, style: .default) { _ in
                self.presenter.loadData()
                self.presenter.restartQuiz()
            }
        case .questionLoadingError:
            UIAlertAction(title: model.buttonText, style: .default) { _ in
                self.presenter.moveToNextStep()
            }
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}
