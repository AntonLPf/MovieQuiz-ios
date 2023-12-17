//
//  QuizStorageProtocol.swift
//  MovieQuiz
//
//  Created by Антон Шишкин on 17.12.23.
//

import Foundation

protocol QuizStorageProtocol {
    
    func addNew(record: GameRecord) throws
    
    func loadDb() throws -> DataBase
    
}
