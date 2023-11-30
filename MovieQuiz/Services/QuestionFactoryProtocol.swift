//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 16.11.23.
//

import Foundation

protocol QuestionFactoryProtocol {
    
    var delegate: QuestionFactoryDelegate? { get set }

    func requestNextQuestion()
    
    func loadData()
}
