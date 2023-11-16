//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 16.11.23.
//

import UIKit

class AlertPresenter: AlertPresenterProtocol {
    var delegate: AlertPreseterDelegate?
    
    func show(_ model: AlertModel) {
        let alert = UIAlertController(title: model.title,
                                      message: model.message,
                                      preferredStyle: .alert)
                
        let action = UIAlertAction(title: model.buttonText, style: .default) { _ in
            self.delegate?.didDismissResultAlert()
        }
        
        alert.addAction(action)
        
        delegate?.present(alert, animated: true) {
            model.completion()
        }
    }    
}
