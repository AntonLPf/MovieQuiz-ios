//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 18.12.23.
//

import Foundation

protocol MovieQuizViewControllerProtocol: AnyObject {

    func show(question: QuizQuestionViewModel)
    
    func highlightImageBorder(isCorrectAnswer: Bool)
    
    func disableButtons()
    
    func enableButtons()
    
    func showLoadingIndicator()
    
    func hideLoadingIndicator()
    
    func showAlert(model: AlertModel)
}
