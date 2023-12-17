//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 18.11.23.
//

import Foundation

protocol StatisticServiceProtocol {
    
    var totalAccuracy: Float { get }
    
    var gamesCount: Int { get }
    
    var bestGame: GameRecord { get }
    
    var storage: StorageProtocol { get }
    
}

class StatisticService: StatisticServiceProtocol {
    
    let storage: StorageProtocol
    
    init(store: StorageProtocol) {
        self.storage = store
    }
    
    var totalAccuracy: Float {
        var result: Float = 0.0
        
        if let db = try? storage.loadDb() {
            var quizPercentages: Set<Float> = []
            
            for record in db.records {
                quizPercentages.insert(record.accuracy)
            }
            
            let totalRecords = db.records.count
            
            var totalPercentage: Float = 0.0
            if totalRecords > 0 {
                totalPercentage = quizPercentages.reduce(0, +) / Float(totalRecords)
            }
            result = totalPercentage
        }
        
        return result
    }
    
    var gamesCount: Int {
        var result = 0
        
        if let db = try? storage.loadDb() {
            result = db.records.count
        }
        
        return result
    }
    
    var bestGame: GameRecord {
        var result = GameRecord(correctAnswersCount: 0, questionsCount: 0, date: Date())
        
        if let db = try? storage.loadDb(), var bestGame = db.records.first {
            for game in db.records {
                if game.accuracy > bestGame.accuracy {
                    bestGame = game
                }
            }
            
            result = bestGame
        }
        
        return result
        
    }
}
