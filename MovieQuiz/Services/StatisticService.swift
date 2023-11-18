//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 18.11.23.
//

import Foundation

protocol StatisticService {
    
    var totalAccuracy: Float { get }
    var gamesCount: Int { get }
    var bestGame: GameRecord { get }    
}
