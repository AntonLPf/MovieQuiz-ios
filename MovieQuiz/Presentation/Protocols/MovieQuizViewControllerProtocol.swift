//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 18.12.23.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {
    
    func showFinishAlert(model: QuizResultsViewModel)
    
    func show(quiz step: QuizStepViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func disableButtons()
    
    func enableButtons()
    
    func showLoadingIndicator()
    
    func hideLoadingIndicator()
    
    func showNetworkError(message: String, alertType: AlertModel.AlertType)
}
