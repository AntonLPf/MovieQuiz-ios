//
//  QuizStatisticServiceProtocol.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 17.12.23.
//

import Foundation

protocol QuizStatisticServiceProtocol {
    
    var totalAccuracy: Float { get }
    
    var gamesCount: Int { get }
    
    var bestGame: GameRecord { get }
    
    var storage: QuizStorageProtocol { get }
    
}
