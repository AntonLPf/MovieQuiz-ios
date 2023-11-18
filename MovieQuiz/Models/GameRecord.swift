//
//  GameRecord.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 16.11.23.
//

import Foundation

struct GameRecord: Codable, Identifiable {
    let id: UUID
    let correctAnswersCount: Int
    let questionsCount: Int
    let date: Date
    
    init(correctAnswersCount: Int, questionsCount: Int, date: Date) {
        self.id = UUID()
        self.correctAnswersCount = correctAnswersCount
        self.questionsCount = questionsCount
        self.date = date
    }
    
    var accuracy: Float {
        Float(correctAnswersCount) / Float(questionsCount) * 100
    }
}
