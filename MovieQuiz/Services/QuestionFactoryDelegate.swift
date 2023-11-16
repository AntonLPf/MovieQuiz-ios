//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 16.11.23.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    
    func didReceiveNextQuestion(question: QuizQuestion?)
    
}
