//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 18.11.23.
//

import Foundation

class StatisticServiceImplementation: StatisticService {
    
    let store: StorageProtocol
    
    init(store: StorageProtocol) {
        self.store = store
    }
        
    var totalAccuracy: Float {
        var result: Float = 0.0
        
        if let db = try? store.loadDb() {
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
        
        if let db = try? store.loadDb() {
            result = db.records.count
        }
        
        return result
    }
    
    var bestGame: GameRecord {
        var result = GameRecord(correctAnswersCount: 0, questionsCount: 0, date: Date())
        
        if let db = try? store.loadDb(), var bestGame = db.records.first {
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
