import UIKit

final class MovieQuizViewController: UIViewController {
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet private weak var textLabel: UILabel!
    
    @IBOutlet private weak var counterLabel: UILabel!
    
    @IBOutlet private weak var yesButton: UIButton!
    
    @IBOutlet private weak var noButton: UIButton!
    
    private let questions: [QuizQuestion] = [
        QuizQuestion(
            image: "The Godfather",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Dark Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Kill Bill",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Avengers",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Deadpool",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "The Green Knight",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: true),
        QuizQuestion(
            image: "Old",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "The Ice Age Adventures of Buck Wild",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Tesla",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false),
        QuizQuestion(
            image: "Vivarium",
            text: "Рейтинг этого фильма больше чем 6?",
            correctAnswer: false)
    ]
    
    private var currentQuestionIndex = 0
    
    private var correctAnswers = 0
        
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                          question: model.text,
                          questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        imageView.layer.borderWidth = 0
    }
    
    private var logger = Logger()
        
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showNextQuestionOrResults()
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        handle(givenAnswer: false)
    }
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
        handle(givenAnswer: true)
    }
    
    private func handle(givenAnswer: Bool) {
        
        let currentQuestion = questions[currentQuestionIndex]
        
        let isCorrect = currentQuestion.correctAnswer == givenAnswer
        
        if isCorrect {
            correctAnswers += 1
        }
        
        showAnswerResult(isCorrect: isCorrect)
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.cornerRadius = 20
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        disableButtons()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            
            let resultRecord = ResultsRecord(numberOfCorrectAnswers: correctAnswers,
                                             numberOfqQuestions: questions.count,
                                             date: Date())
            logger.add(resultRecord)
            
            let resultViewModel = getResultViewModel(from: resultRecord)
            
            show(quiz: resultViewModel)
        } else {
            currentQuestionIndex += 1
            let question = questions[currentQuestionIndex]
            let convertedToModel = convert(model: question)
            show(quiz: convertedToModel)
        }
        
        enableButtons()
        
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
        }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(title: result.title,
                                      message: result.text,
                                      preferredStyle: .alert)
        let action = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.correctAnswers = 0
            let question = self.questions[self.currentQuestionIndex]
            let convertedToModel = self.convert(model: question)
            self.show(quiz: convertedToModel)
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func disableButtons() {
        yesButton.isEnabled = false
        noButton.isEnabled = false
    }
    
    private func enableButtons() {
        yesButton.isEnabled = true
        noButton.isEnabled = true
    }
    
    struct Logger {
        
        private var records: [ResultsRecord] = []
        
        mutating func add(_ record: ResultsRecord) {
            records.append(record)
        }
        
        func getNumberOfRecords() -> Int {
            records.count
        }
        
        func getBestResult() -> ResultsRecord? {
            guard var bestResult = records.first else { return nil }
            
            let numberOfQuizes = records.count
            
            for index in 1..<numberOfQuizes {
                let record = records[index]
                if record.accuracy > bestResult.accuracy {
                    bestResult = record
                }
            }
            
            return bestResult
        }
        
        func getAverageAccuracy() -> Float {
            var quizPercentages: [Float] = []

            for record in records {
                quizPercentages.append(record.accuracy)
            }
            
            let totalQuizzes = records.count
            let totalPercentage = quizPercentages.reduce(0, +) / Float(totalQuizzes)
                                    
            return totalPercentage
        }
    }
    
    struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    struct QuizResultsViewModel {
      let title: String
      let text: String
      let buttonText: String
    }
    
    struct ResultsRecord {
        let numberOfCorrectAnswers: Int
        let numberOfqQuestions: Int
        let date: Date
        
        var accuracy: Float {
            Float(numberOfCorrectAnswers) / Float(numberOfqQuestions) * 100
        }
    }
}
