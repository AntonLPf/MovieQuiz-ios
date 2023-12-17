//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 16.11.23.
//

import UIKit

class AlertPresenter: AlertPresenterProtocol {
    weak var delegate: AlertPreseterDelegate?
    
    func show(_ model: AlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
        alert.view.accessibilityIdentifier = "Game results"
        
        let action: UIAlertAction = switch model.type {
        case .result:
            UIAlertAction(title: model.buttonText, style: .default) { _ in
                self.delegate?.didDismissResultAlert()
            }
        case .networkError:
            UIAlertAction(title: model.buttonText, style: .default) { _ in
                self.delegate?.didDismissNetworkErrorAlert()
            }
        case .questionLoadingError:
            UIAlertAction(title: model.buttonText, style: .default) { _ in
                self.delegate?.didDismissQuestionLoadingErrorAlert()
            }
        }
        
        alert.addAction(action)
        
        delegate?.present(alert, animated: true) {
            model.completion()
        }
    }    
}
