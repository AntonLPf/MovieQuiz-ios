//
//  Logger.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 16.11.23.
//

import Foundation

struct Logger {
    
    private var records: [ResultsRecord] = []
    
    mutating func add(_ record: ResultsRecord) {
        records.append(record)
    }
    
    func getNumberOfRecords() -> Int {
        records.count
    }
    
    func getBestResult() -> ResultsRecord? {
        guard var bestResult = records.first else { return nil }
        
        let numberOfQuizes = records.count
        
        for index in 1..<numberOfQuizes {
            let record = records[index]
            if record.accuracy > bestResult.accuracy {
                bestResult = record
            }
        }
        
        return bestResult
    }
    
    func getAverageAccuracy() -> Float {
        var quizPercentages: [Float] = []

        for record in records {
            quizPercentages.append(record.accuracy)
        }
        
        let totalQuizzes = records.count
        let totalPercentage = quizPercentages.reduce(0, +) / Float(totalQuizzes)
                                
        return totalPercentage
    }
}
