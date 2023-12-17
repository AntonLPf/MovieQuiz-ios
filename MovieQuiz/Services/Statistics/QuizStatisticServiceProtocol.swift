//
//  QuizStatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 17.12.23.
//

import Foundation

protocol QuizStatisticServiceProtocol {
    
    func getQuizStatistics(from database: QuizDataBase) -> QuizStatistics
    
}
