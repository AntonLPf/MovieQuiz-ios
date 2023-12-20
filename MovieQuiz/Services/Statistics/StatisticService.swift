//
//  StatisticServiceImplementation.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 18.11.23.
//

import Foundation

class StatisticService: QuizStatisticServiceProtocol {
    
    func getQuizStatistics(from database: QuizDataBase) -> QuizStatistics {
        QuizStatistics(numberOfGames: getGamesCount(from: database),
                       totalAccuracy: getTotalAccuracy(from: database),
                       bestGame: getBestGame(from: database))
    }
        
    private func getTotalAccuracy(from database: QuizDataBase) -> Float {
        
        var result: Float = 0.0
        var quizPercentages: Set<Float> = []
        
        for record in database.records {
            quizPercentages.insert(record.accuracy)
        }
        
        let totalRecords = database.records.count
        
        if totalRecords > 0 {
            result = quizPercentages.reduce(0, +) / Float(totalRecords)
        }
        
        return result
    }
    
    private func getGamesCount(from database: QuizDataBase) -> Int {
        database.records.count
    }
    
    private func getBestGame(from database: QuizDataBase) -> GameRecord {
        var result = GameRecord(correctAnswersCount: 0, questionsCount: 0, date: Date())
        
        guard var bestGame = database.records.first else { return result }
        
        for game in database.records {
            if game.accuracy > bestGame.accuracy {
                bestGame = game
            }
        }
        
        result = bestGame
        
        return result
    }    
}
