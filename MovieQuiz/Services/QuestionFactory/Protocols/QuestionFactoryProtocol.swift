//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 17.12.23.
//

import Foundation

protocol QuestionFactoryProtocol {
    
    var delegate: QuestionFactoryDelegate? { get set }

    func requestNextQuestion()
    
    func loadData()
}
