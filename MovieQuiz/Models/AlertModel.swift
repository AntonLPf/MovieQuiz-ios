//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 16.11.23.
//

import Foundation

struct AlertModel {
    
    let title: String
    
    let message: String
    
    let buttonText: String
    
    let type: AlertType
    
    let completion: () -> ()
    
    enum AlertType: String {
        case quizResult
        case networkError
        case questionLoadingError
    }
    
}
