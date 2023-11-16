//
//  ResultsRecord.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 16.11.23.
//

import Foundation

struct ResultsRecord {
    let numberOfCorrectAnswers: Int
    let numberOfqQuestions: Int
    let date: Date
    
    var accuracy: Float {
        Float(numberOfCorrectAnswers) / Float(numberOfqQuestions) * 100
    }
}
